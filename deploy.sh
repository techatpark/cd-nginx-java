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
    echo "Start the backup at $1"

    curl -X POST localhost:$1/actuator/shutdown
    nohup java -jar -Dserver.port=$1 -Dname=backup_jar_dpl deployment/_deploy.jar > logs/backup.log &

    echo "Will wait for backup server to start"
    sleep 2m
    echo "Backup server started"

    # Stop Main Servers
    for (( i=1; i <= $2; i++ ))
    do
    PORT=`expr $i + $1` 
    echo "Shutting down $PORT"
    curl -X POST localhost:$PORT/actuator/shutdown
    done

    # kill $(ps -A | grep [d]eploy_jar_dpl | awk '{print $1}')

    mv deployment/__deploy.jar deployment/deploy.jar

    # Start Main Serversnginx
    for (( i=1; i <= $2; i++ ))
    do
    PORT=`expr $i + $1`
    echo "Starting $PORT"
    nohup java -jar -Dserver.port=$PORT -Dname=deploy_jar_dpl deployment/deploy.jar > logs/server$PORT.log &
    done


    echo "Will wait for archivel"
    sleep 2m
    echo "Resume Archivel"

    # Archive
    curl localhost:$1
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


