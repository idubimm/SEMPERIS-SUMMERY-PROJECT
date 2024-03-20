#!/bin/bash
loop-until-success() {
    # URL=$1 
    COMMAND2EXECUTE=$1
    MAXATTEMPTS=$2 
    INTERVAL=$3

    echo "loop-until-success -> command to execute = $COMMAND2EXECUTE"


    # Current attempt counter
    attempt=1

    # Loop until the command succeeds or we reach the maximum number of attempts
    while [ $attempt -le $MAXATTEMPTS ]; do
        echo "Attempt $attempt of $MAXATTEMPTS..."
        sleep $INTERVAL
        $COMMAND2EXECUTE

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