#!/bin/bash

def activePostgres = docker ps -a |grep postgers-idubi|wc |awk 'BEGIN {FS=" "}{print $1}'
echo 'active postgres containers : $activePostgres'
if ["$activePostgres" -eq 0];then
    def checkInactivePostgresContainers = docker ps |grep postgers-idubi|wc |awk 'BEGIN {FS=" "}{print $1}'
    echo 'inactive postgres containers : $checkInactivePostgresContainers'
    if ["$checkStopedPostgresContainers" -eq 0];then
        we need to run the image , but first login to docker 
        def loggedIn = sh(script: 'docker info | grep -i "Username"', returnStatus: true)
                                            if (loggedIn != 0) {
                                                // Not logged in, perform login using credentials stored in Jenkins
                                                withCredentials([usernamePassword(credentialsId: 'idubi_docker', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                                                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                                                }
                                            }          
       def checkStopedPostgresContainers = docker ps |grep postgers-idubi|wc |awk 'BEGIN {FS=" "}{print $1}'

    else 

fi



if [ -r somefile ]; then        
    content=$(cat somefile)
elif [ -f somefile ]; then        
    echo "The file 'somefile' exists but is not readable to the script."
else echo "The file 'somefile' does not exist."
fi
