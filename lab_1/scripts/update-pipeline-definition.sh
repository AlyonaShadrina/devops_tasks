#!/usr/bin/env bash

if ! [ -f "$1" ]; then
  echo "$1 file not found"
  exit 1
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
  
  exit 1
fi

JSON_CONTENT="$(cat $1)"

# owner="basename $(dirname $(git remote get-url origin))"

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

# OPTS=$(getopt -o '' -a --longoptions 'configuration:,owner:,branch::,poll-for-source-changes::' -n "$0" -- "$@")
OPTS=$(getopt -o '' -a --longoptions 'configuration:,owner:,branch:,poll-for-source-changes:' -n "$0" -- "$@")
eval set -- "$OPTS"
while true; do
  case "$1" in
    --configuration )
        configuration=$2
        shift 2
        ;;
    --owner )
        owner=$2
        shift 2
        ;;
    --branch )
        branch=${2}
        # branch=${2:-"main"}
        shift 2
        ;;
    --poll-for-source-changes )
        pollForSourceChanges=${2}
        # pollForSourceChanges=${2:-"false"}
        shift 2
        ;;
    --)
        shift
        break
        ;;
  esac
done

# if [ -z "$configuration" ]; then
#   echo "--configuration was not provided"
#   exit
# fi

set_branch () {
  JSON_CONTENT="$(jq --arg branch $branch '.pipeline.stages[0].actions[0].configuration.Branch = $branch' <<< $JSON_CONTENT)";
  
  echo "pipeline.stages[0].actions[0].configuration.Branch : $branch"
}
set_owner () {
  JSON_CONTENT="$(jq --arg owner $owner '.pipeline.stages[0].actions[0].configuration.Owner = $owner' <<< $JSON_CONTENT)";
  
  echo "pipeline.stages[0].actions[0].configuration.Owner: $owner"
}
set_poll () {
  JSON_CONTENT="$(jq --arg pollForSourceChanges $pollForSourceChanges '.pipeline.stages[0].actions[0].configuration.PollForSourceChanges = $pollForSourceChanges' <<< $JSON_CONTENT)";
  
  echo "pipeline.stages[0].actions[0].configuration.PollForSourceChanges: $pollForSourceChanges"
}
set_env () {
  JSON_CONTENT="${JSON_CONTENT//"{{BUILD_CONFIGURATION value}}"/$configuration}"   
  
  echo "{{BUILD_CONFIGURATION value}} replaced with $configuration"
}

remove_metadata
increment_version

if ! [ -z $branch ]; then
  set_branch
fi

if ! [ -z "$pollForSourceChanges" ]; then
  set_poll
fi

if ! [ -z "$owner" ]; then
  set_owner
fi

if ! [ -z "$configuration" ]; then
  set_env
fi

newFileName="pipeline-$(date +'%Y-%m-%d-%H-%M-%S-%s').json"

echo "$JSON_CONTENT" > $newFileName && echo "New pipeline file is created"
