# Dependencies

1.  npm install --save react-router-dom redux react-redux
2.  npm install --save-dev
3.  npm install babel-eslint --save-dev
4.  npm install prettier-eslint --save-dev
5.  For Testing
6.  npm install enzyme enzyme-adapter-react-16 jest-cli fetch-mock react-test-renderer redux-mock-store --save-dev
7.  asdf
8.  asdf
9.  asdf
10. Beautify plugin with prettifier breaks jsx
    #for testing
11. npm install enzyme enzyme-adapter-react-16 --save-dev

# Style Guide

# Linting

# Important libraries

1.  Reselect
2.  Immutable
3.  Normalizr

## Improve stability of your app

1.  One great way of improving the stability of your app is moving global states to the query string. In other words you need defined the scope of the page in the query string. You keep the location of the page and use `componentWillReceiveProps` to listen for changes in the query string. That way when you refresh the page everything should be working like it’s supposed to.
2.  Anything that is time consuming and requires synchronous time do it in `componentDidMount`.

### Rules

1.  scene can container scene/container/component
2.  container can contain container and component only
3.  component can contain only other component but not container and scene

### STEP wise guide

1.  Create a container(even in scene folder)
2.  Create a selector for stuff calling in mapstatetoprops and also change it to makemapstatetoprops
3.  create actions eg (AUTH_INIT, AUTH_SUCCESS, AUTH_FAIL)
4.  create reducers to update state, use immutable js in this one
5.  then create saga for all the side effects and listen to all the side effect action dispatches

# Hosting with node

https://medium.com/@adhasmana/how-to-deploy-react-and-node-app-on-aws-a-better-approach-5b22e2ed2da2

<!-- docker kubernetes course notes -->

1. docker ecosystem - docker client, server, machine, Images, Hub, Compose,

sample commands docker run -it redis

commands
docker version

docker run hello-world

- draw.io for mocks

docker image - FS file system snapshot, startup command

feature of namespacing and control groups in OSes -> specific to Linux

kernel is the intermediate layer

nodejs -> kernel -> file creation etc.

# docker run

`docker run <image name> <command override>`

# list all running containers

`docker ps`

# list all containers ever created

`docker ps --all`

## container lifecycle

1. create container

`docker create <image name>`

2. start container

`docker start -a <container_id>`
-a => attach => watch for output from the container

3. docker run = docker create + docker start

# Restarting stopped containers

`docker ps --all` , `docker start -a <imageid>`

# removing stopped containers

`docker system prune`

#retrieving Log outputs
`docker logs <container_id>`

# stopping containers

`docker stop <container_id>`
terminate signal, takes sometime

`docker kill <container_id>`
kill signal, shut down right now

# multi-command containers

docker run redis

## executing commands in running containers

`docker exec -it <container_id> <command>`
-it to input to the container
-i is to attach the current terminal to the container
-t for formatting

# getting a command prompt in a container

`docker exec -it <container_id> sh`

ctrl + D to exit if ctrl + c is not working

# starting with a shell

`docker run -it <image_name> <command_name>`
`docker run -it busybox sh`

#contianer isolation

# CREATING DOCKER IMAGES

Dockerfile > Docker Client > Docker Server > Usable Image!

# building a docker file

## Steps

1. # use existing docker image as a base image
2. # Download and install Dependencies
3. Tell the image to do when it starts a container

###Sample docker file
FROM alpine

WORKDIR

COPY ./package.json ./
RUN apk add --update redis
COPY ./ ./ # use this after larger operations

CMD ["redis-server]

## file complete

`docker build .`
`docker run <container_id>`

- alipne

writing a dockerfile == being given a comp with no OS and being told to install Chrome

# rebuilds from cache

in a dockerfile if order of operations change, docker builds an image from scratch, if

# NOTE

if you want to change your dockerfile, make the changes as far down below as possible

# Tagging an Image

`abhimanyu / redis : latest`
`docker id / repo/project_name : version`

`docker build -t abhimanyu/redis:latest .`

`docker run abhimanyu/redis:latest`

- version no. is the tag name

# MANUAL IMAGE GENERATION WITH DOCKER COMMIT

`docker ps`
`docker commit -c 'CMD ["redis-server"]' <container_id>`

TO bind the app to port, here u need to open localhost:5000 in the browser to access the application
`docker run -p 5000:8080 abhimanyu/simpleweb`

# Minimizing cache busting and rebuilding

# DOCKER COMPOSE

To start up multiple Docker containers at the same time.

`docker-compose up` = `docker run myimage`
`docker-compose up --build` = `docker build .` && `docker run myimage`

# STOPPING DOCKER COMPOSE CONTAINERS

docker-compose up -d
docker-compose down

# AUTOMATIC CONTAINERS RESTART

restart policies

1. no, always, on-failure, unless-stopped

`docker-compose ps` from the directory

DEV => TESTING => DEPLOYMENT

feature => Master => Travis CI => AWS Hosting

# DIfferent files for dev and production

Dockerfile.dev for dev
`docker build -f Dockerfile.dev .`

`docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app <container_id>`

## SAMPLE docker-compose.yml

version: '3'
services:
web:
build:
context: .
dockerfile: Dockerfile.dev
ports: - "3000:3000"
volumes: - /app/node_modules - .:/app
tests:
build:
context: .
dockerfile: Dockerfile.dev
ports: - "3000:3000"
volumes: - /app/node_modules - .:/app
command: ["npm", "run", "test"]

# RUN Tests

`docker run -it <container_id> npm run test`

# DYNAMICALLY REFRESH TESTS ON TEST UPDATE

`docker ps`
`docker exec -it <container_id> npm run test`

# MULTI-STEP DOCKER BUILD

FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html

# TRAVIS CI

`docker exec -it <container_id> npm run test -- --coverage`

## SAMPLE TRAVIS CI FILE

.travis.yml

sudo: required
services:

- docker
  before_install:
- docker build -t abhimanyu/docker-react -f Dockerfile.dev .

script:

- docker run abhimanyu/docker-react npm run test -- --coverage

deploy:
provider: elasticbeanstalk
region: "us-west-2"
app: "docker"
env: "Docker-env"
bucket_name: docker # search s3 bucket list for this name, app_name
on:
branch: master

access_key_id: $AWS_ACCESS_KEY
secret_key_access:
  secure: "$AWS_SECRET_KEY"

# AUTOMATIC BUILD CREATION

# AWS

Elastic Beanstalk -
Create new Application => Create one now => Web server env => Base Config > Platform > docker > Create

## TRAVIS CONFIG FOR DEPLOYMENT

## AWS

### IAM create users

programatic-access only

- username - `docker-react-travis-ci`
- attach existing policy
- search beanstalk > provide full access to AWS elastic bean stalk

> ENV variables in travis ci > repo settings > AWS_ACCESS_KEY

# Exposing port is very important in Dockerfile or the app wont work

# MULTIPLE CONTAINERS WITH DOCKER AND DOCKER COMPOSE UP

docker-compose.yml
version: "3"
services:
postgres:
image: 'postgres:latest'
redis:
image: 'redis:latest'
api:
build: Dockerfile.dev
context: ./server
volumes:

- /app/node_modules
- ./server:/app
  environment:
- REDIS_HOST=redis
- REDIS_PORT=6379

client:
build: Dockerfile.dev
context: ./client
volumes:

- /app/node_modules
- ./client:/app
  environment:
- REDIS_HOST=redis
- REDIS_PORT=6379

nginx:
image: nginx
restart: "always"
ports:

- 3050:80
  build:
  dockerfile: Dockerfile.dev
  context: ./nginx

# NGINX CONFIG FOR MULTI SERVER APP

default.conf

upstream client {
server client:3000;
}

upstream api {
server server:5000;
}

server {
listen 80;
location / {
proxy_pass http://client;
}

location /sockjs-node {
proxy_pass http://client; # to allow react dev server
proxy_http_version 1.1;
proxy_set_header Upgrade \$http_upgrade;
proxy_set_header Connection "Upgrade";
}

location / {
rewrite /api/(.\*) /\$1 break; # change \* to only star
proxy_pass http://server;
}
}

## NGINX Dockerfile.dev

FROM nginx
COPY ./default.conf /etc/nginx/conf.d/default.conf # check path from docs

# PRODUCTION MULTI-CONTAINER DEPLOY

#### Create Dockerfile in server, client and worker

Just change the CMD from `CMD ["npm","run","dev"]` to `CMD ["npm","run","start"]`

# MULTIPLE NGINX INSTANCES

inside travis file login to docker in single line

- `echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_ID" --password-stdin`

# MULTI-DOCKER DEFINITION FILE FOR AWS

Dockerrun.aws.json
{
"AWSEBDockerrunVersion": 2,
"containerDefinitions":[
{
"name": "client",
"image": "abhimanyu/multi-client",
"hostname": "client", # this is the name that we have used in docker-compose.yaml file
"essential": false, # set this to true and if this crashes all other containers will be stopped
"memory": 128 # in MB, need more research
},
{
"name": "nginx",
"image": "abhimanyu/multi-nginx",
"hostname": "nginx",
"essential": false,
"memory": 128 # in MB, need more research
"portMappings": [{
"hostPort": 80,
"containerPort": 80,
}],
"links": ["client", "server"]

},

]
}

## CREATING THE EB ENVIRONMENT

in creating a new application > Base Configuration > Platform . CHoose Multi-Container Docker instead of Docker

## MANAGED DATA SERVICE PROVIDERS

AWS Elastic Cache to handle redis
AWS Relational DB

## CREATE VPC ON AWS

For EB INSTANCES
RDS Instance
Redis Instance

## CREATING RDS INSTANCE

## Setting the same security group for all the instances in the VPC

## AWS Setting ENV variables

## Difference between kubernetes and elastic beanstalk, kubernetes allows to make multiple instances of a single docker container , whereas EB makes multiple instances of entire container group

# KUBERNETES

- expects images to be prebuilt
- One config file per object
- Manually setup networking

### adding configuration files

### DEVELOMENT ENV

minikube - local only
kubectl for both

`brew install kubectl`
`brew cask install minikube`
`minikube start`
`minikube status` - just for checking

### PRODUCTION ENV

kubectl for both

apiVersion: v1 or apps/v1
kind: Pod/Service/ReplicaController/Event/Endpoints/Namespace/componentStatus - object Types depends on apiVersion
metadata:
name: client-pod
labels:
component: web
spec:
containers: - name: client
image: stephengrider/multi-client
ports: - containerPort: 3000

- TYPES OF OBJECTS

  - Services - sets up networking in kubernetes Cluster
  - Pods - runs one or more closely related containers

- POD IS A GROUPING OF CONTAINERS
- is the smallest thing that we can deploy to run a single container
- why would we make a pod?
  - to run one or more containers
-

* What is a SERVICE object?

  - ClusterIP
  - NodePort - Expose a container to the outside world - only good for dev purposes!!
  - LoadBalancer
  - Ingress

- every KUBERNETES cluster has a KUBE-PROXY

# OBJECT LINKING IS DONE USING `labels`

- NodePort Service collection of ports
  - port - port of the pod
  - targetPort - inside of the port to which we are going to target the traffic to
  - nodePort - type into our browser - 30000 - 32767

# COMMAANDS

- `kubectl apply -f <filename>`
- `kubectl apply -f <directoryname with all config files>`

- apply - change the current configuration of our cluster
- -f - we want to specify a file that has the config changes
- <filename> - patht to the file with config changes

- what happened
  - deployment file was passed to Master(kube-apiserver - responsible for running all the containers - I need, I have running, Name)

* `kubectl get pods`
* `kubectl get pods -o wide` - node and ip info
* `kubectl get services`
* `kubectl get pv`
* `kubectl get pvc`
* `kubectl get storageclass`
* `kubectl get secrets`
* `kubectl describe <object type> <object name>`
* `kubectl delete -f <config file>` - delete a running object
* `kubectl set image <object_type>/<object_name> <container_name> = <new image to use>`

  sample command
  `kubectl set image deployment/client-deployment client=stephengrider/multi-client:v5`

- `kubectl create secret generic <secret_name> --from-literal key=value`

* types of secret

  - generic/docker-registry/tls

  sample command
  `kubectl create secret generic pgpassword --from-literal PGPASSWORD=password123`

- `minikube ip` - to type in the browser

* WHAT IS KUBERNETES?
  - a system to deploy containerized applications
  - Nodes are individual machines(vms) that run containers
  - Masters are machines with a set of progras to manage nodes
  - To deploy something we update the desired state of the master with a config file.

- Imperative Deployments
  - Do exactly these steps to arrive at this container setup.
- Declarative Deployments
  - Our container setup should look like this, make it happen.

# LIMITATIONS IN CONFIG UPDATES

- not able to update the name, port of the pods

- Solution USING DEPLOYMENT OBJECTS
- DEPLOYMENT is similar to PODS

# DIFFERENCE BETWEEN PODS AND DEPLOYMENT

- PODS
  - Runs a single set of containers
  - Good for one-off dev purposes
  - rarely used directly in production
- Deployment
  - Runs a set of identical pods(1 or more)
  - Monitors the state of each pod, updating as necessary
  - Good for dev
  - Good for production

* every single pod gets it's own IP address

# Triggering the deployment to recreate our pods with the latest version of our image

kubernetes issue tag #33664

- delete Pods Manually
- tagging with version

- use an imperative command to update the image version

# CONNECT DOCKER-CLIENT WITH VM'S DOCKER-SERVER AND NOT WITH DOCKER FOR MAC

`eval $(minikube docker-env)` - only configures current window temporarily
`minikube docker-env` - to check what the command DOCKER-SERVER

#### FOR DEBUGGING

- `docker ps` -> `docker logs <containerid>`
- `docker exec -it <container_id> sh`
- `kubectl get pods` -> `kubectl logs <podsname>`
- `kubectl exec -it <podname> sh`

- `docker system prune -a` - to clean everything out in case of a caching issue
  docker ps sytem prrune - a

`kubectl exect -it <podname> sh`

# THE PATH TO PRODUCTION

- Traffic -> Ingress Service -> ClusterIP(Deployments(multi-server pod)/Pods)
- Create config file for each service and deployment
- Test locally on minikube
- Create a Github/Travis flow to build images and deploy
- Deploy app to a cloud provider

# Combining config into a single file

use `---` at the end of one config

# NOTE

### MULTI-WORKER INSTANCE DOES NOT REQUIRE ANY PORT AS IT IS NOT GOING TO BE ACCESSED DIRECTLY

# The need for volumes with Databases

- PERSISTENT VOLUME CLAIM

- WHAT IS A VOLUME AND WHY WE NEED ONE WITH POSTGRES?
- because this is where all the data is stored and if a pod/container crashes all of the data is lost.
- this is where volume comes in?

# KUBERNETES VOLUMES

- Persistent Volume Claim
- Persistent Volume
- Volume - Not exactly the same thing as a Docker volume

## PERSISTENT VOLUME CLAIM VS - PERSISTENT VOLUME

- database-persistent-volume-claim.yaml file
- accessModes
  - ReadWriteOnce - can be used by a single node
  - ReadOnlyMany - multiple nodes can read from this
  - ReadWriteMany - multiple nodes can read and write
- kubernetes allocates PersistentVolumeClaim

# SETUP ENV VARIABLES

# LOADBALANCER SERVICES

- legacy service

# INGRESSE SERVICE

- main purspose to get some traffic to your app
- Nginx Ingress
- nginx-ingress/kubernetes-ingress

- nginx-ingress routes multiple requests from one customer directly to the same pod, bypassing clusterIP service, it's kind of difficult to do it manually

- TO enable ingress locally

  - go to https://kubernetes.github.io/ingress-nginx/deploy/
  - `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml`
  - `minikube addons enable ingress`

- writing an ingress config
  - nginx.ingress.kubernetes.io/rewrite-target: / - will remove /api from the request

# AWS vs Google Cloud
