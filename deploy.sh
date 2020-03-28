#!/bin/sh

setup()
{
    mkdir -p deployment
    mkdir -p deployment_history
    mkdir -p logs

    ARTIFACT_NAME=$(ls *.jar)
    
    echo "Deploying $ARTIFACT_NAME" 

    # Start Backup
    mv $ARTIFACT_NAME deployment/_deploy.jar # Backup
    cp deployment/_deploy.jar deployment/__deploy.jar # Unused
    
    printf "Starting the backup at $1"
    nohup java -jar -Dserver.port=$1 -Dname=backup_jar_dpl deployment/_deploy.jar > logs/backup.log &

    while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:$1)" != "200" ]]; do echo -ne " ." ; sleep 5; done

    printf "\nStarted the backup at $1"

    # Stop Main Servers
    for (( i=1; i <= $2; i++ ))
    do
    PORT=`expr $i + $1` 
    printf "\nShutting down $PORT"
    curl -X POST localhost:$PORT/actuator/shutdown
    done

    # kill $(ps -A | grep [d]eploy_jar_dpl | awk '{print $1}')

    mv deployment/__deploy.jar deployment/deploy.jar

    # Start Main Serversnginx
    for (( i=1; i <= $2; i++ ))
    do
    PORT=`expr $i + $1`
    printf "\nStarting $PORT"
    nohup java -jar -Dserver.port=$PORT -Dname=deploy_jar_dpl deployment/deploy.jar > logs/server$PORT.log &
    done


    printf "\nWill wait for archivel"
    sleep 2m
    printf "\nResume Archivel"

    # Archive
    curl -X POST localhost:$1/actuator/shutdown
    DATE_TIME_WITHOUT_SPACES=$(date)
    mv deployment/_deploy.jar deployment_history/$(echo ${DATE_TIME_WITHOUT_SPACES// /_}).jar
    # kill $(ps -A | grep [b]ackup_jar_dpl | awk '{print $1}')

}

###
# Main body of script starts here
###
reset
setup 8000 2

# 8000 8001 8002 ...


