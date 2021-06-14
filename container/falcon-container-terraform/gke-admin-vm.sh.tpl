#!/bin/bash

export HOME=/root

main(){
    set -x
    install_deps

    fetch_falcon_secrets_from_gcp
    download_falcon_sensor
    push_falcon_sensor_to_gcr

    deploy_falcon_container_sensor
    deploy_vulnerable_app
    set +x
    wait_for_vulnerable_app
}

deploy_falcon_container_sensor(){
    injector_file="/yaml/injector.yaml"
    docker run --rm --entrypoint installer "$FALCON_IMAGE_URI" -cid "$CID" -image "$FALCON_IMAGE_URI" > "$injector_file"

    configure_gke_access
    kubectl apply -f "$injector_file"

    kubectl wait --for=condition=ready pod -n falcon-system -l app=injector
}

wait_for_vulnerable_app(){
    echo "Waiting for GKE load balancer to assign public IP to vulnerable.example.com"
    while [ -z "$(get_vulnerable_app_ip)" ]; do
        sleep 5
    done;
}

get_vulnerable_app_ip(){
    kubectl get service vulnerable-example-com  -o yaml -o=jsonpath="{.status.loadBalancer.ingress[*].ip}"
}

deploy_vulnerable_app(){
    kubectl apply -f /yaml/vulnerable.example.yaml
}

export CLOUDSDK_CORE_DISABLE_PROMPTS=1
export DEBIAN_FRONTEND=noninteractive

configure_gke_access(){
    while ! gcloud container clusters get-credentials "${CLUSTER_NAME}" --zone "${GCP_ZONE}"; do
        sleep 7
    done
}

push_falcon_sensor_to_gcr(){
    FALCON_IMAGE_URI="gcr.io/${GCP_PROJECT}/falcon-sensor:latest"
    docker tag "falcon-sensor:$local_tag" "$FALCON_IMAGE_URI"
    while ! docker push "$FALCON_IMAGE_URI"; do
        sleep 10
        gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io
    done
}

download_falcon_sensor(){
    tmpdir=$(mktemp -d)
    pushd "$tmpdir" > /dev/null
      falcon_sensor_download --os-name=Container
      local_tag=$(cat ./falcon-sensor-* | docker load -q | grep 'Loaded image: falcon-sensor:' | sed 's/^.*Loaded image: falcon-sensor://g')
    popd > /dev/null
    rm -rf "$tmpdir"
}

fetch_falcon_secrets_from_gcp(){
    set +x
    FALCON_CLIENT_ID=$(gcloud secrets versions access latest --secret="${tenant}-FALCON_CLIENT_ID")
    FALCON_CLIENT_SECRET=$(gcloud secrets versions access latest --secret="${tenant}-FALCON_CLIENT_SECRET")
    FALCON_CLOUD=$(gcloud secrets versions access latest --secret="${tenant}-FALCON_CLOUD")
    CID=$(gcloud secrets versions access latest --secret="${tenant}-FALCON_CID")
    export FALCON_CLIENT_ID
    export FALCON_CLIENT_SECRET
    export FALCON_CLOUD
    export CID
    set -x
}

install_deps(){
    snap install docker
    snap install kubectl --classic

    gofalcon_version=0.2.2
    pkg=gofalcon-$gofalcon_version-1.x86_64.deb
    wget -q -O $pkg https://github.com/CrowdStrike/gofalcon/releases/download/v$gofalcon_version/$pkg
    apt install ./$pkg > /dev/null

    mkdir -p /yaml
    wget -q -O /yaml/vulnerable.example.yaml https://raw.githubusercontent.com/isimluk/vulnapp/master/vulnerable.example.yaml
}

progname=$(basename "$0")

die(){
    echo "$progname: fatal error: $*"
    exit 1
}

err_handler() {
    echo "Error on line $1"
}

trap 'err_handler $LINENO' ERR


MOTD=/etc/motd
LIVE_LOG=$MOTD.log

(
    echo "--------------------------------------------------------------------------------------------"
    echo "Welcome to the admin instance for your gke demo cluster. Installation log follows"
    echo "--------------------------------------------------------------------------------------------"
) > $LIVE_LOG
echo 'ps aux | grep -v grep | grep -q google_metadata_script_runner.startup && tail -n 1000 -f '$LIVE_LOG >> /etc/bash.bashrc
: > $MOTD

set -e -o pipefail

main "$@" >> $LIVE_LOG 2>&1

detection_uri(){
    aid=$(
        kubectl exec deploy/vulnerable.example.com -c falcon-container -- \
            falconctl -g --aid | awk -F '"' '{print $2}')
    echo "https://falcon.crowdstrike.com/activity/detections/?filter=device_id:%27$aid%27&groupBy=none"
}

(
    echo "--------------------------------------------------------------------------------------------"
    echo "Demo initialisation completed"
    echo "--------------------------------------------------------------------------------------------"
    echo "vulnerable.example.com is available at http://$(get_vulnerable_app_ip)/"
    echo "detections will appear at $(detection_uri)"
    echo "--------------------------------------------------------------------------------------------"
    echo "Useful commands:"
    echo "  # to get all running pods on the cluster"
    echo "  sudo kubectl get pods --all-namespaces"
    echo "  # to get Falcon agent/host ID of vulnerable.example.com"
    echo "  sudo kubectl exec deploy/vulnerable.example.com -c falcon-container -- falconctl -g --aid"
    echo "  # to view Falcon injector logs"
    echo "  sudo kubectl logs -n falcon-system deploy/injector"
    echo "  # to uninstall the vulnerable.example.com"
    echo "  sudo kubectl delete -f /yaml/vulnerable.example.yaml"
    echo "  # to uninstall the falcon container protection"
    echo "  sudo kubectl delete -f /yaml/injector.yaml"
    echo "--------------------------------------------------------------------------------------------"
) >> $LIVE_LOG

mv $LIVE_LOG $MOTD

for pid in $(ps aux | grep tail.-n.1000.-f./etc/motd | awk '{print $2}'); do
    kill "$pid"
done

