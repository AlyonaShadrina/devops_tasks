#!/usr/bin/env bash

if ! [ -f "$1" ]; then
  echo "$1 file not found"
  exit
fi

packagesNeeded='jq'
if ! command -v $packagesNeeded &> /dev/null
then
  echo "$packagesNeeded command required but could not be found"
  echo ""

  if [ -x "$(command -v apk)" ];       then echo "sudo apk add --no-cache $packagesNeeded"
  elif [ -x "$(command -v apt-get)" ]; then echo "sudo apt-get install $packagesNeeded"
  elif [ -x "$(command -v dnf)" ];     then echo "sudo dnf install $packagesNeeded"
  elif [ -x "$(command -v zypper)" ];  then echo "sudo zypper install $packagesNeeded"
  fi
  
  exit
fi

JSON_CONTENT="$(cat $1)"

remove_metadata () {
  metadata="$(jq '. | .metadata' <<< $JSON_CONTENT)";

  if [ "$metadata" = 'null'  ]; then
    echo "There is no metadata to remove."
    exit
  fi

  JSON_CONTENT="$(jq 'del(.metadata)' <<< $JSON_CONTENT)";
  echo "Metadata is removed"
}

increment_version () {
  version="$(jq '. | .pipeline.version' <<< $JSON_CONTENT)";

  if [ $version = 'null'  ]; then
    echo "There is no version to increment"
    exit
  fi

  newNumber=$(($version + 1))
  JSON_CONTENT="$(jq --arg newVersion $newNumber '.pipeline.version = ($newVersion|tonumber)' <<< $JSON_CONTENT)";
  echo "New version is $newNumber"
}

remove_metadata
increment_version

echo "$JSON_CONTENT"




# newFileName="pipeline-$(date +'%Y-%m-%d-%H-%M-%S-%s').json"
# cp $1 $newFileName

# echo "New pipeline file is created"
# echo "$newFileName"
