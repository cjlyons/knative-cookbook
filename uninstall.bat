REM reset docker and minikube
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

cd ..