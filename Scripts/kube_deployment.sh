envsubst < ./kube-manifests/service.yaml | kubectl apply -f -
envsubst < ./kube-manifests/deployment.yaml | kubectl apply -f -
