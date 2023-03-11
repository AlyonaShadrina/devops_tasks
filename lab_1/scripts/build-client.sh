#!/usr/bin/env bash

# Check if all required thing are present

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst);
fi

if [ -z "${ENV_CONFIGURATION+xxx}" ]; then
    echo "ENV_CONFIGURATION was not provided";
    exit
fi

if ! command -v node &> /dev/null
then
    echo "node command could not be found"
    exit
fi

if ! command -v zip &> /dev/null
then
    echo "zip command could not be found"
    exit
fi

# Go to project

read -r -p "Provide path to project: " dirPath

# Build project

cd $dirPath
echo "Starting installation of dependencies..."
npm ci
echo "Starting $ENV_CONFIGURATION build..."
ng build --configuration=$ENV_CONFIGURATION

# Archive project build

cd ./dist
ARCHIVE=./client-app.zip

if [ -f "$ARCHIVE" ]; then
  rm $ARCHIVE
  echo "Old $ARCHIVE is removed."
fi

zip -r client-app.zip app
echo "New $ARCHIVE is created."
