#!/bin/sh

ARTIFACT_NAME="vts"

# Stop Runing
ps aux | grep -v grep | grep deploy_$ARTIFACT_NAME | awk '{print $2}' | xargs kill
# Start New
nohup java -jar -Dname=deploy_$ARTIFACT_NAME artifacts/$ARTIFACT_NAME/demo-0.0.1-SNAPSHOT.jar > $ARTIFACT_NAME.log &