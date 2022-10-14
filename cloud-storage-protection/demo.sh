#!/bin/bash
RD="\033[1;31m"
GRN="\033[1;33m"
NC="\033[0;0m"
LB="\033[1;34m"
all_done(){
    echo -e "$LB"
    echo '╭━━━┳╮╱╱╭╮╱╱╱╭━━━┳━━━┳━╮╱╭┳━━━╮'
    echo '┃╭━╮┃┃╱╱┃┃╱╱╱╰╮╭╮┃╭━╮┃┃╰╮┃┃╭━━╯'
    echo '┃┃╱┃┃┃╱╱┃┃╱╱╱╱┃┃┃┃┃╱┃┃╭╮╰╯┃╰━━╮'
    echo '┃╰━╯┃┃╱╭┫┃╱╭╮╱┃┃┃┃┃╱┃┃┃╰╮┃┃╭━━╯'
    echo '┃╭━╮┃╰━╯┃╰━╯┃╭╯╰╯┃╰━╯┃┃╱┃┃┃╰━━╮'
    echo '╰╯╱╰┻━━━┻━━━╯╰━━━┻━━━┻╯╱╰━┻━━━╯'
    echo -e "$NC"
}

env_destroyed(){
    echo -e "$RD"
    echo '╭━━━┳━━━┳━━━┳━━━━┳━━━┳━━━┳╮╱╱╭┳━━━┳━━━╮'
    echo '╰╮╭╮┃╭━━┫╭━╮┃╭╮╭╮┃╭━╮┃╭━╮┃╰╮╭╯┃╭━━┻╮╭╮┃'
    echo '╱┃┃┃┃╰━━┫╰━━╋╯┃┃╰┫╰━╯┃┃╱┃┣╮╰╯╭┫╰━━╮┃┃┃┃'
    echo '╱┃┃┃┃╭━━┻━━╮┃╱┃┃╱┃╭╮╭┫┃╱┃┃╰╮╭╯┃╭━━╯┃┃┃┃'
    echo '╭╯╰╯┃╰━━┫╰━╯┃╱┃┃╱┃┃┃╰┫╰━╯┃╱┃┃╱┃╰━━┳╯╰╯┃'
    echo '╰━━━┻━━━┻━━━╯╱╰╯╱╰╯╰━┻━━━╯╱╰╯╱╰━━━┻━━━╯'
    echo -e "$NC"
}

# GCP Project ID
gcp_get_project_id() {
    # Get the GCP project ID
    if [ -z "$(gcloud config get-value project 2> /dev/null)" ]; then
        project_ids=$(gcloud projects list --format json | jq -r '.[].projectId')
        project_count=$(wc -w <<< "$project_ids")
        if [ "$project_count" == "1" ]; then
            gcloud config set project "$project_ids"
        else
            gcloud projects list
            echo "Multiple pre-existing GCP projects found. Please select project using the following command before re-trying"
            echo "  gcloud config set project VALUE"
            exit 1
        fi
    fi
    echo "$(gcloud config get-value project 2> /dev/null)"
}

### API FALCON CLOUD LOGIC ###
cs_cloud() {
    case "${cs_falcon_cloud}" in
        us-1)      echo "api.crowdstrike.com";;
        us-2)      echo "api.us-2.crowdstrike.com";;
        eu-1)      echo "api.eu-1.crowdstrike.com";;
        us-gov-1)  echo "api.laggar.gcw.crowdstrike.com";;
        *)         die "Unrecognized Falcon Cloud: ${cs_falcon_cloud}";;
    esac
}

json_value() {
    KEY=$1
    num=$2
    awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'"$KEY"'\042/){print $(i+1)}}}' | tr -d '"' | sed -n "${num}p"
}

die() {
    echo -e "$RD"
    echo "Error: $*" >&2
    echo -e "$NC"
    exit 1
}

cs_verify_auth() {
    if ! command -v curl > /dev/null 2>&1; then
        die "The 'curl' command is missing. Please install it before continuing. Aborting..."
    fi
    token_result=$(echo "client_id=$FID&client_secret=$FSECRET" | \
                curl -X POST -s -L "https://$(cs_cloud)/oauth2/token" \
                    -H 'Content-Type: application/x-www-form-urlencoded; charset=utf-8' \
                    --dump-header "${response_headers}" \
                    --data @-)
    token=$(echo "$token_result" | json_value "access_token" | sed 's/ *$//g' | sed 's/^ *//g')
    if [ -z "$token" ]; then
        die "Unable to obtain CrowdStrike Falcon OAuth Token. Response was $token_result"
    fi
}

cs_set_base_url() {
    region_hint=$(grep -i ^x-cs-region: "$response_headers" | head -n 1 | tr '[:upper:]' '[:lower:]' | tr -d '\r' | sed 's/^x-cs-region: //g')
    if [ -z "${region_hint}" ]; then
        die "Unable to obtain region hint from CrowdStrike Falcon OAuth API, something went wrong."
    fi
    cs_falcon_cloud="${region_hint}"
}

# Ensure script is ran in cloud-storage-protection directory
[[ -d demo ]] && [[ -d cloud-function ]] || die "Please run this script from the cloud-storage-protection root directory"

if [ -z "$1" ]
then
   echo "You must specify 'up' or 'down' to run this script"
   exit 1
fi
MODE=$(echo "$1" | tr [:upper:] [:lower:])
if [[ "$MODE" == "up" ]]
then
    # Get the GCP project ID
    PROJECT_ID=$(gcp_get_project_id)
    echo "--------------------------------------------------"
    echo "Using GCP project ID: $PROJECT_ID"
    echo "--------------------------------------------------"
	read -sp "CrowdStrike API Client ID: " FID
	echo
	read -sp "CrowdStrike API Client SECRET: " FSECRET
    echo

    # Make sure variables are not empty
    if [ -z "$FID" ] || [ -z "$FSECRET" ]
    then
        die "You must specify a valid CrowdStrike API Client ID and SECRET"
    fi

    # Verify the CrowdStrike API credentials
    echo "Verifying CrowdStrike API credentials..."
    cs_falcon_cloud="us-1"
    response_headers=$(mktemp)
    cs_verify_auth
    # Get the base URL for the CrowdStrike API
    cs_set_base_url
    echo "Falcon Cloud URL set to: $(cs_cloud)"
    # Cleanup tmp file
    rm "${response_headers}"

    UNIQUE=$(echo $RANDOM | md5sum | sed "s/[[:digit:].-]//g" | head -c 8)
    # Initialize Terraform
    if ! [ -f demo/.terraform.lock.hcl ]; then
        terraform -chdir=demo init
    fi
    # Apply Terraform
	terraform -chdir=demo apply -compact-warnings --var falcon_client_id=$FID \
        --var falcon_client_secret=$FSECRET --var project_id=$PROJECT_ID \
        --var base_url=$(cs_cloud) --var unique_id=$UNIQUE --auto-approve
    echo -e "$GRN\nPausing for 30 seconds to allow configuration to settle.$NC"
    sleep 30
    all_done
	exit 0
fi
if [[ "$MODE" == "down" ]]
then
    # Destroy Terraform
	terraform -chdir=demo destroy -compact-warnings --auto-approve
    env_destroyed
	exit 0
fi
die "Invalid command specified."
