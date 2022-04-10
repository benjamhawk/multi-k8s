# we are adding two tags: latest and then the current git SHA of the latest commit
# this will force docker to rebuild the image if the code changes
docker build -t benjamhawk/multi-client:latest -t benjamhawk/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t benjamhawk/multi-server:latest -t benjamhawk/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t benjamhawk/multi-worker:latest -t benjamhawk/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push the new images to the docker hub
docker push benjamhawk/multi-client:latest
docker push benjamhawk/multi-server:latest
docker push benjamhawk/multi-worker:latest

docker push benjamhawk/multi-client:$SHA
docker push benjamhawk/multi-server:$SHA
docker push benjamhawk/multi-worker:$SHA

# apply the k8s config
kubectl apply -f k8s

# imperatively set the images inside the deployments to be the new images
kubectl set image deployments/server-deployment server=benjamhawk/multi-server:$SHA
kubectl set image deployments/client-deployment client=benjamhawk/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=benjamhawk/multi-worker:$SHA
