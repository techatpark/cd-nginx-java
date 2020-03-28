#!/bin/sh

HOST=localhost

#modify the app
DATE_TIME=$(date)
# Change RestServiceApplication to return DATE_TIME

sed -i "s+DATETIME+$DATE_TIME+g" spring-rest-api/src/main/java/com/example/restservice/RestServiceApplication.java

#building a jar
cd spring-rest-api
./mvnw clean package
cd ../

#deploy jar
mv spring-rest-api/target/*.jar .
bash deploy.sh

RESPONSE=$(curl $HOST) 

if [ "$RESPONSE" == "$DATE_TIME" ]; then
    echo "deployment success"
else
    echo "failed"
fi
# CURL localhost:8080 / DATE_TIME