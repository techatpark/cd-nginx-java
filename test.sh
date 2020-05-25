#!/bin/sh

HOST=localhost:8000

# Change RestServiceApplication to return DATE_TIME
# Simulator for Application Modification
sed -i -e "s/DATETIME/$(date)/g" spring-boot-web/src/main/java/com/example/demo/RestServiceApplication.java
rm spring-boot-web/src/main/java/com/example/demo/*-e

#building a jar
cd spring-boot-web
./mvnw clean package
cd ../

#deploy jar
mv spring-boot-web/target/*.jar .
bash deploy.sh 8000 1

RESPONSE=$(curl $HOST) 

if [ "$RESPONSE" == "$DATE_TIME" ]; then
    echo "deployment success"
else
    echo "failed"
fi
# CURL localhost:8080 / DATE_TIME
