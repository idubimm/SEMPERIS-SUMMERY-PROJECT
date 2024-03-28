#!/bin/bash

start_minikube_if_down() {
    minikubeStatus=$(minikube status)
    running_count=$(echo "$minikubeStatus" | grep -o "Running" | wc -l)
    configured_count=$(echo "$minikubeStatus" | grep -o "Configured" | wc -l)
    if [[ $running_count -eq 3 && $configured_count -eq 1 ]]; then
            echo "Status check for minikube passed --> continue with kubernetes work"
            return 0
    else 
            echo "stating minikube "
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

get_application_ip_and_port(){
    serviceName=$1
    namespace=$2
    # echo $namespace
    # echo $serviceName
    minikubeip=$(minikube ip)
    # echo "minikubeip  -->  $minikubeip"
    port=$(kubectl get svc --namespace=$namespace | awk '//{split($5,a,":|/"); print a[2]}' |grep -Eo '[0-9]+')
    # echo "port  -->  $port"
    echo "$minikubeip:$port"
}
 
delete_active_element(){
      ELEMENTTYPE=$1
      ELEMENTNAME=$2 
      NAMESPACE=$3
      FILE=$4
      #'pods' 'postgres' 'semperis-ns'  './kubernetes/yaml-files/01-postgres.yaml' 
      echo 'inside delete active elements'
      active_elements=$(kubectl get $ELEMENTTYPE --namespace=$NAMESPACE | grep $ELEMENTNAME |wc -l)
      echo "active elements found : active_elements  --> $active_elements"  
      if [ "$active_elements" -gt 0 ]; then
           echo "active elements found : active_elements  --> $active_elements"  
           kubectl delete -f $FILE
      fi
}		

