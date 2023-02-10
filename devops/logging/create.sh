#!/bin/bash

if [[ $# != 1 ]];then
 echo "please pass run to create the cluster"
 exit 10
fi

function run() {

    kubectl apply -f namespace.yaml
    kubectl apply -f storage.yaml
    if [ "$ENV" = "development" ]
    then
        kubectl apply -f es-statefulset-development.yaml
    else
        kubectl apply -f es-statefulset.yaml
    fi
    kubectl apply -f es-service.yaml
    kubectl create configmap fluentd-config --from-file=conf/kubernetes.conf --from-file=conf/fluent.conf --from-file=conf/systemd.conf -n toptal-logging
    kubectl apply -f fluentd.yaml
    if [ "$ENV" = "development" ]
    then
        kubectl apply -f kibana-development.yaml
    else
        kubectl apply -f kibana.yaml
    fi
}

function unrun() {

    kubectl delete -f es-service.yaml
    if [ "$ENV" = "development" ]
    then
        kubectl delete -f es-statefulset-development.yaml
        kubectl delete -f kibana-development.yaml
    else
        kubectl delete -f es-statefulset.yaml
        kubectl delete -f kibana.yaml
    fi
    kubectl delete -f fluentd.yaml
    kubectl delete configmap fluentd-config -n ct-infrastructure
    sleep 60
    PVC_LIST=$(kubectl get pvc -n ct-infrastructure | grep 'data-es-log' | awk  '{ print $1 }')
    for pvc in $PVC_LIST
    do
        echo "$pvc"
        kubectl delete pvc $pvc -n ct-infrastructure
    done
    kubectl delete -f namespace.yaml
}

function help() {
    echo "run - to create tls secrets and load balancer"
    echo "unrun - to delete tls secrets and load balancer"
}

case "${1}"
in
    ("run")
           run ;;
    ("unrun")
            unrun ;;
    ("help") help ;;
    (*) echo "$0 [run|unrun|help]" ;;
esac

