#!/bin/sh

HOST=localhost

#modify the app
DATE_TIME=$(date)
# Change RestServiceApplication to return DATE_TIME

#building a jar
cd spring-rest-api
./mvnw clean package
cd ../

#deploy jar
mv spring-rest-api/target/*.jar .
bash deploy.sh

# CURL localhost:8080 / DATE_TIME