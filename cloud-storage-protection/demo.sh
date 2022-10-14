#!/bin/bash
DG="\033[1;30m"
RD="\033[0;31m"
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


echo -e "\nThis script should be executed from the cloud-storage-protection root directory.\n"
if [ -z "$1" ]
then
   echo "You must specify 'up' or 'down' to run this script"
   exit 1
fi
MODE=$(echo "$1" | tr [:upper:] [:lower:])
if [[ "$MODE" == "up" ]]
then
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
    PROJECT_ID=$(gcloud config get-value project 2> /dev/null)
    echo "--------------------------------------------------"
    echo "      Using GCP project ID: $PROJECT_ID"
    echo "--------------------------------------------------"
	read -sp "CrowdStrike API Client ID: " FID
	echo
	read -sp "CrowdStrike API Client SECRET: " FSECRET

    # Make sure variables are not empty
    if [ -z "$FID" ] || [ -z "$FSECRET" ]
    then
        echo "You must specify a valid CrowdStrike API Client ID and SECRET"
        exit 1
    fi

    UNIQUE=$(echo $RANDOM | md5sum | sed "s/[[:digit:].-]//g" | head -c 8)
    # Initialize Terraform
    if ! [ -f demo/.terraform.lock.hcl ]; then
        terraform -chdir=demo init
    fi
    # Apply Terraform
	terraform -chdir=demo apply -compact-warnings --var falcon_client_id=$FID \
		--var falcon_client_secret=$FSECRET --var project=$PROJECT_ID \
        --var unique_id=$UNIQUE --auto-approve
    echo -e "$RD\nPausing for 30 seconds to allow configuration to settle.$NC"
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
echo "Invalid command specified."
exit 1
