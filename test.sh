#!/bin/sh

docker-compose stop && docker-compose rm -f && docker-compose up -d

HOST=localhost
DATE_TIME=$(date)
R_TEXT='return "'$DATE_TIME'";' 
# Change RestServiceApplication to return DATE_TIME
# Simulator for Application Modification
find . -name 'RestServiceApplication.java' -print0 | xargs -0 sed -i "" "s/DATETIME/$R_TEXT/g"
# rm spring-test/src/main/java/com/example/demo/*-e

# building a jar
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

git checkout -- spring-test/src/main/java/com/example/demo/RestServiceApplication.java
# CURL localhost:8080 / DATE_TIME
