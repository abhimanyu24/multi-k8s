docker build -t abhimanyu90/multi-client:latest -t abhimanyu90/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t abhimanyu90/multi-server:latest -t abhimanyu90/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t abhimanyu90/multi-worker:latest -t abhimanyu90/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push abhimanyu90/multi-client:latest
docker push abhimanyu90/multi-server:latest
docker push abhimanyu90/multi-worker:latest

docker push abhimanyu90/multi-client:$SHA
docker push abhimanyu90/multi-server:$SHA
docker push abhimanyu90/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=abhimanyu90/multi-server:$SHA
kubectl set image deployments/client-deployment client=abhimanyu90/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=abhimanyu90/multi-worker:$SHA
