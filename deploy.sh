#!/bin/sh

cp ../spring-boot-azure/target/demo-0.0.1-SNAPSHOT.jar .

setup()
{
    ARTIFACT_NAME=$(ls *.jar)
    
    echo "Deploying $ARTIFACT_NAME" 

    echo "Start the backup at $1"
    kill $(ps -A | grep [b]ackup_jar_dpl | awk '{print $1}')
    nohup java -jar -Dserver.port=$1 -Dname=backup_jar_dpl $ARTIFACT_NAME > logs/backup.log &


    for (( i=1; i <= $2; i++ ))
    do
    PORT=`expr $i + $1`
    curl -X POST localhost:$PORT/actuator/shutdown
    done

    kill $(ps -A | grep [d]eploy_jar_dpl | awk '{print $1}')

    DATE_TIME_WITHOUT_SPACES=$(date)
    mv deployment/deploy.jar deployment_history/$(echo ${DATE_TIME_WITHOUT_SPACES// /_}).jar
    cp $ARTIFACT_NAME deployment/deploy.jar

    for (( i=1; i <= $2; i++ ))
    do
    PORT=`expr $i + $1`
    nohup java -jar -Dserver.port=$PORT -Dname=deploy_jar_dpl deployment/deploy.jar > logs/server$PORT.log &
    done

    
    #echo "curl -X POST localhost:$1/actuator/shutdown"
    rm $ARTIFACT_NAME

}

###
# Main body of script starts here
###

mkdir -p deployment_history
mkdir -p deployment
mkdir -p logs
setup 1000 5

