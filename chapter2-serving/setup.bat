REM set namespace, optionally use "kubens set chapter-2"
kubectl config set-context --current --namespace=chapter-2

REM deploy revision 1 of the greeter service
kubectl -n chapter-2 apply -f greeter-service.yaml
