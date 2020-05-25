#!/bin/sh

HOST=localhost:8000
DATE_TIME=$(date)
R_TEXT='return "'$DATE_TIME'";' 
# Change RestServiceApplication to return DATE_TIME
# Simulator for Application Modification
sed -i -e "/return/c $R_TEXT" spring-test/src/main/java/com/example/demo/RestServiceApplication.java
rm spring-test/src/main/java/com/example/demo/*-e

building a jar
cd spring-test
./mvnw clean package
cd ../

#deploy jar
mv spring-test/target/*.jar .
bash deploy.sh 8000 1

RESPONSE=$(curl $HOST) 

if [ "$RESPONSE" == "$DATE_TIME" ]; then
    echo "deployment success"
else
    echo "failed"
fi
# CURL localhost:8080 / DATE_TIME
