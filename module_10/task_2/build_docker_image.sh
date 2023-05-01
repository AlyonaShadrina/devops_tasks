#!/usr/bin/env bash

APP_FOLDER="app"

mkdir $APP_FOLDER

git clone git@github.com:EPAM-JS-Competency-center/nestjs-rest-api.git $APP_FOLDER

git checkout feat/devops-cicd-lab

# DATE_NOW=$(date +"%Y-%m-%d-%H-%M-%S")

# TAG="hub_user/react-dev:$DATE_NOW"

# docker build -t $TAG .

# docker push $TAG

# rm -rf $APP_FOLDER