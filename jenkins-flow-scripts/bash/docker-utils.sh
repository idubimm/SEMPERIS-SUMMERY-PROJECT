#!/bin/bash



verify_docker_login(){

USERNAME=$1
PASSWORD=$2

 if ! docker info 2>&1 | grep -q 'ERROR: Cannot connect to the Docker daemon'; then
        echo "Docker is running, checking if logged in..."

        # Check if already logged in by looking for a username in the docker info output
        if docker info 2>&1 | grep -q 'Username'; then
            echo "Already logged into Docker."
        else
            echo "Not logged into Docker, attempting to log in..."
            # Log in to Docker using the provided username and password
            echo $PASSWORD | docker login --username $USERNAME --password-stdin
            if [ $? -eq 0 ]; then
                echo "Docker login successful."
                return 0
            else
                echo "Docker login failed."
                return 1
            fi
        fi
    else
        echo "Docker is not running or you do not have permission to access it."
        return 1
    fi

}

verify_image_exist(){
    IMAGENAME=$1 
    # Check if the image is available in docker 
    availableImage=$(docker images | grep -w "$IMAGENAME" | wc -l)
    if [ "$availableImage" -gt 0 ]; then
         echo "Image $IMAGENAME is available locally."
         return 0
    else
         echo "Image $IMAGENAME is not available locally."
         return 1
    fi
}

verify_container_up(){
    CONTAINERNAME=$1 
    activeContainers=$(docker ps | grep -w "$CONTAINERNAME" | wc -l)
    if [ "$activeContainers" -eq 0 ]; then 
        echo "container $CONTAINERNAME is not active"
        return 1 
    else 
        echo "container $CONTAINERNAME is active "
        return 0
    fi

}

verify_container_available(){
    CONTAINERNAME=$1 
    availableContainers=$(docker ps -a | grep -w "$CONTAINERNAME" | wc -l)
    if [ "$availableContainers" -eq 0 ] ; then 
        echo "container $CONTAINERNAME was not used or deleted"
        return 1 
    else 
        echo "container $CONTAINERNAME was available"
        return 0
    fi
}

prepare_docker_container() {
    DOCKERCONTAINER=$1 
    DOCKERIMAGE=$2
    COMMAND=$3
    USER=$4
    PASS=$5
    
    echo "inside prepare docekr container $DOCKERCONTAINER $USER $PASS "
    if (verify_container_up $DOCKERCONTAINER) ; then
        return 0
    else
        if (verify_container_available $DOCKERCONTAINER) ; then
            echo `docker start $DOCKERCONTAINER`
        else
            if (verify_image_exist $IMAGENAME) ; then
                 echo `$COMMAND`
            else
                if (verify_docker_login $USER $PASS) ; then
                   echo `$COMMAND`
                   return 0
                else 
                   echo "failed to load container $DOCKERCONTAINER " 
                   return 1
                fi
            fi
        fi
    fi
    return 0
}


cleanup_old_local_repo() {
    DOMAIN=$1
    REPONAME=$2
    

    containerExists=$(docker ps -a --format "{{.Image}}" | grep "$REPONAME")
    if [ ! -z "$containerExists" ]; then
        docker rm -f $REPONAME
        docker rmi -f $(docker images "$REPONAME" -q)
    fi

    # Check if the repository image exists
    repoExists=$(docker images | grep "$DOMAIN/$REPONAME")
    if [ ! -z "$repoExists" ]; then
        docker rmi -f $(docker images "$DOMAIN/$REPONAME" -q)
    fi
}

build_docker_image() {
    USER=$1
    PASSWORD=$2 
    DOMAIN=$3
    REPONAME=$4
    PATHTODOCKERFILE=$5
    
    echo "USER             ---> $USER"
    echo "PASSWORD         ---> $PASSWORD"
    echo "DOMAIN           ---> $DOMAIN          "
    echo "REPONAME         ---> $REPONAME        "
    echo "PATHTODOCKERFILE ---> $PATHTODOCKERFILE"


    echo "DOMAIN/REPONAME:lts"  --> $DOMAIN/$REPONAME:lts"
    
    verify_docker_login  $USER $PASSWORD
    cleanup_old_local_repo $DOMAIN $REPONAME
    
    echo `docker build -t "$DOMAIN/$REPONAME:lts" $PATHTODOCKERFILE`

} 

build_docker_compose() {
    #  'src/docker-compose-image.yml'  'flask-crud:lts'    'flasc-compose'
    DOCKERCOMPOSEFILE=$1
    FLASK_BUILD_NAME=$2
    COMPOSE_NAME=$3

    export FLASK_BUILD_NAME=$FLASK_BUILD_NAME
    export COMPOSE_NAME=$COMPOSE_NAME

    echo `docker-compose -f $DOCKERCOMPOSEFILE  up -d`
}

stop_container() {
    CONTAINERNAME=$1
    if docker ps | grep -q "$CONTAINERNAME"; then
        echo `docker stop $CONTAINERNAME`;
    fi
} 

stop_docker_compose() {
    DOCKERCOMPOSEFILE=$1
    FLASK_BUILD_NAME=$2
    COMPOSE_NAME=$3

    export FLASK_BUILD_NAME=$FLASK_BUILD_NAME
    export COMPOSE_NAME=$COMPOSE_NAME


    echo `docker-compose -f $DOCKERCOMPOSEFILE down --remove-orphans`
}