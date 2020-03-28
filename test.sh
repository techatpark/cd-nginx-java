#!/bin/sh

#building a jar
cd spring-rest-api
./mvnw clean package
cd ../

#deploy jar
mv spring-rest-api/target/*.jar .
bash deploy.sh

