#!/bin/sh

cp ../spring-boot-azure/target/demo-0.0.1-SNAPSHOT.jar .

setup()
{
    ARTIFACT_NAME=$(ls *.jar)
    
    echo "Deploying $ARTIFACT_NAME" 

    echo "Start the backup at $1"
    kill $(ps aux | grep 'backup_$1' | awk '{print $2}')
    nohup java -jar -Dserver.port=$1 -Dname=backup_$1 $ARTIFACT_NAME > logs/backup.log &


    for (( i=1; i <= $2; i++ ))
    do
    PORT=`expr $i + $1`
    curl -X POST localhost:$PORT/actuator/shutdown
    done

    for (( i=1; i <= $2; i++ ))
    do
    PORT=`expr $i + $1`
    kill $(ps aux | grep 'deploy_$PORT' | awk '{print $2}')
    done

    cp $ARTIFACT_NAME deployment/deploy.jar

    for (( i=1; i <= $2; i++ ))
    do
    PORT=`expr $i + $1`
    nohup java -jar -Dserver.port=$PORT -Dname=deploy_$PORT deployment/deploy.jar > logs/server$PORT.log &
    done

    DATE_TIME_WITHOUT_SPACES=$(date)
    mv $ARTIFACT_NAME deployment_history/$(echo ${DATE_TIME_WITHOUT_SPACES// /_}).jar
    #echo "curl -X POST localhost:$1/actuator/shutdown"

}

###
# Main body of script starts here
###

mkdir -p deployment_history
mkdir -p deployment
mkdir -p logs
setup 1000 5

