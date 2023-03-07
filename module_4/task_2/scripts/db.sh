# TODO: add full description
declare -A COMMANDS_HELP
COMMANDS_HELP[add]="add help"
COMMANDS_HELP[backup]="backup help"
COMMANDS_HELP[restore]="restore help"
COMMANDS_HELP[find]="find help"
COMMANDS_HELP[list]="list help"

typeset fileName=users.db
typeset fileDir=../data
typeset filePath=$fileDir/$fileName

check_table () {
  if [[ ! -f $filePath ]];
  then
      read -r -p "users.db does not exist. Do you want to create it? [Y/n] " answer
      answer=${answer,,}
      if [[ "$answer" =~ ^(yes|y)$ ]];
      then
          touch $filePath
          echo "File ${fileName} is created."
      else
          echo "File ${fileName} must be created to continue. Try again." >&2
          exit 1
      fi
  fi
}
validate_latin () {
  if ! [[ $1 =~ ^[A-Za-z_]+$ ]]; then 
    echo "must be latin letters only"
    exit 1
  fi
}
add () {
  read -p "Enter user name: " username
  validate_latin $username

  read -p "Enter user role: " role
  validate_latin $role

  echo "${username}, ${role}" | tee -a $filePath
}
backup () {
  backupFileName=$(date +'%Y-%m-%d-%H-%M-%S-%s')-$fileName.backup
  cp $filePath $fileDir/$backupFileName

  echo "New backup is created"
  echo "$fileDir/$backupFileName"
}
restore () {
  backupFileName="$(ls $fileDir/*-$fileName.backup | tail -n 1)"

  if ! [[ -f $backupFileName ]]; then
    echo "No backup file found."
    exit 1
  fi

  cat $backupFileName > $filePath

  echo "Backup is restored from $backupFileName"
}
find () {
  echo "find called"
}
list () {
  echo "list called"
}
help () {
  echo "Available commands:"
  for K in "${!COMMANDS_HELP[@]}"; do
    # TODO: print as table
    echo $K ${COMMANDS_HELP[$K]};
  done
}

if [[ $(type -t "$1") == function ]]; then
  check_table
  echo "$($1)"
else 
  help
fi
