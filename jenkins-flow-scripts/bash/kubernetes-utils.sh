#!/bin/bash

start_minikube_if_down() {
    minikubeStatus=$(minikube status)
    running_count=$(echo "$minikubeStatus" | grep -o "Running" | wc -l)
    configured_count=$(echo "$minikubeStatus" | grep -o "Configured" | wc -l)
    if [[ $running_count -eq 3 && $configured_count -eq 1 ]]; then
            echo "Status check for minikube passed , may continue woth kubernetes work"
            return 0
    else 
            echo stating minikube 
            echo `minikube start`
    fi   
}

start_minikube_tunel_if_stopped() {
    minikubeTerminal=$(ps -ef | grep 'minikube tunnel'| wc -l)
    if [ "$minikubeTerminal" -ne 2 ]; then 
        echo "starting minikube tunnel to support  LoadBalancer service"
        echo `minikube tunnel`
    else 
        echo "services Load Balnce is supported"
    fi
} 


