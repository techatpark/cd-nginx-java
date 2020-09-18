#!/bin/sh

# Start Docker
docker-compose stop && docker-compose rm -f && docker-compose up -d

HOST=localhost/api
DATE_TIME=$(date)

# Change RestServiceApplication to return DATE_TIME
# Simulator for Application Modification
find . -name 'RestServiceApplication.java' -print0 | xargs -0 sed -i "" "s/DATETIME/$DATE_TIME/g"
# rm spring-test/src/main/java/com/example/demo/*-e

# building a jar
cd spring-test
./mvnw clean package
cd ../

git checkout -- spring-test/src/main/java/com/example/demo/RestServiceApplication.java

#deploy jar
ARTIFACT_NAME=$(ls spring-test/target/*.jar) 

source spring-boot-deploy.sh

deploy $ARTIFACT_NAME 8000 2 10

# rm -rf dep-*

RESPONSE=$(curl $HOST) 

if [ "$RESPONSE" == "$DATE_TIME" ]; then
    echo "deployment success"
else
    echo "failed $RESPONSE" 
fi


# CURL localhost:8080 / DATE_TIME
