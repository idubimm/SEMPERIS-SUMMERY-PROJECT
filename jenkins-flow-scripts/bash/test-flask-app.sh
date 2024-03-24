#!/bin/bash



# Make POST request to flask app and capture the HTTP status code and message
validate_flask_execution() {
    
    URL=$1 
                
    response_body=$(curl --location --request POST "$URL/ping" -s -w '\n%{http_code}' -o -)
    http_status=$(echo "$response_body" | tail -n1)
    echo "response_body = $response_body"
    response_json=$(echo "$response_body" | head -n3)
    echo "response_json = $response_json"
    echo "http_status = $http_status"
    # Check if the status code is 200
    if [ "$http_status" -eq 200 ]; then
        message=$(echo $response_json | jq -r '.message')
        # check if returned pong in message
        if [ "$message" = "pong" ]; then
            echo "Success: The request returned status 200, and message:pong."
            return 0
        else
            echo "Failure: The request returned status $http_status."
            return 1     
        fi
    else 
        echo "Failure: The request returned status $http_status."
        return 1
    fi  
}


validate_flask_in_loop() {
    URL=$1 
    MAXATTEMPTS=$2 
    INTERVAL=$3


    # Current attempt counter
    attempt=1

    # Loop until the command succeeds or we reach the maximum number of attempts
    while [ $attempt -le $MAXATTEMPTS ]; do
        echo "Attempt $attempt of $MAXATTEMPTS..."
        sleep $INTERVAL
        validate_flask_execution $URL

        # Check if the command was successful
        if [ $? -eq 0 ]; then
            echo "Command succeeded."
            return 0 
        else
            echo "Command failed."
            if [ $attempt -eq $MAXATTEMPTS ]; then
              return 1 
            fi
        fi
        # Increment the attempt counder
        ((attempt++))
    done
}