REM clean up everything that might already exist, run as admin for net cmds
cd bin
bash stop-minikube.sh
minikube delete
docker system prune -a -f

REM restart docker
net stop com.docker.service
taskkill /IM "Docker Desktop.exe" /F
net start com.docker.service
start "" "c:\program files\docker\docker\Docker Desktop.exe"
sleep 90

REM setup minikube
bash start-minikube.sh
minikube addons enable registry

REM setup minikube hosts file
cd ..\apps\minikube-registry-helper
kubectl apply -n kube-system -f registry-aliases-config.yaml
kubectl apply -n kube-system -f node-etc-hosts-update.yaml
bash patch-coredns.sh

REM install istio
cd ..\..\bin
bash install-istio.sh

REM install knative
REM kubectl apply --selector knative.dev/crd-install=true --filename "https://github.com/knative/serving/releases/download/v0.12.0/serving.yaml"
REM kubectl apply --selector knative.dev/crd-install=true --filename "https://github.com/knative/eventing/releases/download/v0.12.0/eventing.yaml"
kubectl apply --selector knative.dev/crd-install=true --filename "https://github.com/knative/serving/releases/download/v0.13.3/serving-crds.yaml"
kubectl apply --selector knative.dev/crd-install=true --filename "https://github.com/knative/eventing/releases/download/v0.13.7/eventing-crds.yaml"
REM kubectl apply --selector networking.knative.dev/certificate-provider!=cert-manager --filename "https://github.com/knative/serving/releases/download/v0.12.0/serving.yaml"
kubectl apply --selector networking.knative.dev/certificate-provider!=cert-manager --filename "https://github.com/knative/serving/releases/download/v0.13.3/serving.yaml"
sleep 60
REM kubectl apply --selector networking.knative.dev/certificate-provider!=cert-manager --filename "https://github.com/knative/eventing/releases/download/v0.12.0/eventing.yaml"
kubectl apply --selector networking.knative.dev/certificate-provider!=cert-manager --filename "https://github.com/knative/eventing/releases/download/v0.13.7/eventing.yaml"
sleep 60

REM point your shell to minikube's docker-daemon
@FOR /f "tokens=*" %%i IN ('minikube -p knativecookbook docker-env') DO @%%i
docker images --format {{.Repository}}

REM setup namespaces (switch to the namespace using "kubens set chapter-2" )
kubectl create namespace chapter-2
kubectl create namespace chapter-3
kubectl create namespace chapter-4
kubectl create namespace chapter-5
kubectl create namespace chapter-6
kubectl create namespace chapter-7

cd ..