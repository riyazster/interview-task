#!/bin/bash
#for i in configmaps secrets services volumes deploymentconfigs; do echo $i; kubectl apply -Rf $i/; done
read -p "Enter application name:" app_name
read -p "Enter environments seperated with space:" app_env
echo "Creating folder structure please wait"
for env in $app_env
do
    for configs in deploymentconfigs configmaps services
    do
        mkdir -p $app_name-$env/$configs/
    done
done