export ENVIRONMENT=$1
export NAMESPACE=$2
export DOCKER_TAG=$3
envsubst < ./kube-manifests/service.yaml | kubectl apply -f -
envsubst < ./kube-manifests/deployment.yaml | kubectl apply -f -
