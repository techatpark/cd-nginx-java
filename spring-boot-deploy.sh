#!/bin/sh

deploy()
{
    reset

    DEPLOY_DIRECTORY=dep-$(date +"%d-%m-%Y-%H-%M-%S")

    mkdir $DEPLOY_DIRECTORY

    echo "Deploying $1 to $DEPLOY_DIRECTORY" 

    # Safety check for deployment
    # mv will fail if the jar is inbetween copying . 
    mv $1 $DEPLOY_DIRECTORY

    cd $DEPLOY_DIRECTORY

    ARTIFACT_NAME=$(ls *.jar) 

    # Preparing Subdirectories for each instnace
    # based on port number
    for (( i=0; i <= $3; i++ ))
    do
    PORT=`expr $i + $2`
    mkdir $PORT
    cd $PORT

    SERVICE="[s]erver.port=$PORT"
    PID=$(ps aux | grep $SERVICE | awk '{print $2}')

    if [ $PID = '' ]; 
        then 
        echo "Application is not running @ $PORT"; 
        else 
        echo "Application is running @ $PORT with Process ID $PID need to be stopped"
        echo "Requesting shutdown @ $PORT"
        curl -X POST localhost:$PORT/actuator/shutdown
        echo "."
        echo "Wait for shutdown @ $PORT"
        sleep $4;    

        if ps -p $PID > /dev/null
            then
                echo "cleanup @ $PORT"
                kill $PID
        fi

    fi
    

    echo "Starting $1 @ $PORT" 
    nohup java -jar -Dserver.port=$PORT ../$ARTIFACT_NAME > /dev/null &
    cd ..
    done

    cd ..
    

    echo "Started below instances" 
    ps aux | grep '[s]erver.port=' | awk '{print $2}'

}




