#!/bin/bash

SERVER_HOST_DIR="$PWD/nestjs-rest-api"
CLIENT_HOST_DIR="$PWD/shop-react-redux-cloudfront"

SERVER_REMOTE_DIR=/var/app/lab2_server
CLIENT_REMOTE_DIR=/var/www/lab2_client

SSH_ALIAS="ubuntu-sshuser"

check_remote_dir_exists() {
  echo "Check if remote directories exist"

  if ssh $SSH_ALIAS "[ ! -d $1 ]"; then
    echo "Creating: $1"
	  ssh -t $SSH_ALIAS "sudo bash -c 'mkdir -p $1 && chown -R sshuser $1'"
  else
    echo "Clearing: $1"
    ssh $SSH_ALIAS "sudo -S rm -r $1"
  fi
}

check_remote_dir_exists $SERVER_REMOTE_DIR
check_remote_dir_exists $CLIENT_REMOTE_DIR

echo "---> Building backend..."
echo $SERVER_HOST_DIR
cd "$SERVER_HOST_DIR"
npm run build

echo "---> Copying backend files to server..."
scp -Cr dist/ $SSH_ALIAS:$SERVER_REMOTE_DIR
scp -Cr package.json $SSH_ALIAS:$SERVER_REMOTE_DIR

echo "---> Building frontend..."
echo $CLIENT_HOST_DIR
cd "$CLIENT_HOST_DIR"
npm run build
echo "---> Copying frontend files to server..."
scp -Cr "$CLIENT_HOST_DIR/dist" $SSH_ALIAS:$CLIENT_REMOTE_DIR

echo "---> Building and transfering - COMPLETE <---"