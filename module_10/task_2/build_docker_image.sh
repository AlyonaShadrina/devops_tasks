#!/usr/bin/env bash

APP_FOLDER="app"

mkdir $APP_FOLDER

git clone -b feat/devops-cicd-lab git@github.com:EPAM-JS-Competency-center/nestjs-rest-api.git $APP_FOLDER

DATE_NOW=$(date +"%Y-%m-%d-%H-%M-%S")

TAG="shaadrina/module-10-task-nestjs-rest-api:$DATE_NOW"

docker build -t $TAG .

docker push $TAG

rm -rf $APP_FOLDER