#!/usr/bin/env bash

# $1 <<<  first and unique argument to pass is a method <apply> or <delete>

export METHOD=$1

usage() {
    echo "Usage:  $0 <METHOD>"
    exit 1
}

if [ $# -ne 1 ]
then
    usage
fi

#start minikube
#minikube start
#check minikube status
#minikube status

#create namespaces
kubectl ${METHOD} -f /kube-config/namespaces.yaml

#deploy mongo secret values
kubectl ${METHOD} -f /kube-config/mongo/mongo-secret.yaml
kubectl ${METHOD} -f /kube-config/mongo/mongo-configmap.yaml
#mongoDB deployment
kubectl ${METHOD} -f /kube-config/mongo/mongo-deployment.yaml
#mongo express deployment
kubectl ${METHOD} -f /kube-config/mongo/mongo-express.yaml

#zookeeper deployment
kubectl ${METHOD} -f /kube-config/kafka/zookeeper-deployment.yaml

#kafka deployment
kubectl ${METHOD} -f /kube-config/kafka/kafka-deployment.yaml

#customer-webservice deployment
kubectl ${METHOD} -f /kube-config/customer-ws/customer-deployment.yaml

#expose all services with cmd lines
##kubectl expose deployment customer-ws-deployment --type=LoadBalancer
##kubectl expose deployment mongo-express --type=LoadBalancer

#start minikube dashboard
#minikube dashboard --url
