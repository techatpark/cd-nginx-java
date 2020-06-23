#!/bin/sh

setup()
{
    mkdir -p deployment
    mkdir -p logs

    ARTIFACT_NAME=$(ls *.jar)
    
    echo "Deploying $ARTIFACT_NAME" 

    printf "Starting the backup at $1"
    nohup java -jar -Dserver.port=$1 -Dname=backup_jar_dpl $ARTIFACT_NAME > logs/backup.log &
    v0=1
    while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:$1)" != "200" ]]; 
    do 
        if [ $v0 -eq 15 ]
        then
            printf "Problem in stating port $1"
            break
        fi
        echo -ne " ." ; 
        v0=`expr $v0 + 1`;
        sleep 5; 
    done

    printf "\nStarted the backup at $1"

    
    # Stop Main Servers
    for (( i=1; i <= $2; i++ ))
    do
    PORT=`expr $i + $1`
    v1=1 
    printf "\nShutting down $PORT"
    curl -X POST localhost:$PORT/actuator/shutdown
    while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:$PORT)" == "200" ]]; 
    do
        if [ $v1 -eq 15 ]
        then
            printf "Problem in shoutDown port $PORT"
            break
        fi 
        echo -ne " ." ; 
        sleep 5;
        v1=`expr $v1 + 1`;
    done
    done

    cp $ARTIFACT_NAME deployment/deploy.jar

    # Start Main Serversnginx
    for (( i=1; i <= $2; i++ ))
    do
        PORT=`expr $i + $1`
        printf "\nStarting $PORT"
        v2=1
        nohup java -jar -Dserver.port=$PORT -Dname=deploy_jar_dpl deployment/deploy.jar > logs/server$PORT.log &
        while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:$PORT)" != "200" ]]; 
        do 
            if [ $v2 -eq 15 ]
            then
                printf "Problem in stating port $PORT"
                break
            fi
            echo -ne " ." ; 
            v2=`expr $v2 + 1`; 
            sleep 5; 
        done
    done
    
    # Archive
    printf "\nStopping the backup at $1"
    curl -X POST localhost:$1/actuator/shutdown
    rm $ARTIFACT_NAME
    printf "\nStopped the backup at $1"

}

###
# Main body of script starts here
###
reset
setup $1 $2

# 8000 8001 8002 ...


