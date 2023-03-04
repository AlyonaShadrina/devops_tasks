#!/usr/bin/env bash
clear
threshold=${1:-10}

while true; do 
  echo "The threshold is $threshold%"
  echo "----------------------------"

  df_output=$(df -h -t ntfs -t ext4); 

  # loop over df table
  while IFS= read -r line; do
    # find used percentage
    used_perc=$(grep -o -E '[[:digit:]]+%' <<< "$line")

    # if no percentage, then it's header
    if [ -z "$used_perc" ]; then
      echo "$line"
      continue
    fi

    # calculate free disk space
    used_perc_digit=$(sed 's/.$//' <<< $used_perc)
    free_disk_space_perc=$((100-used_perc_digit))

    if [ "$free_disk_space_perc" -lt "$threshold" ]; then
      echo -e "\e[31m$line ✘ - Only $free_disk_space_perc% left\e[0m";
    else
      echo -e "\e[32m$line ✓\e[0m";
    fi
  done <<< "$df_output"

  sleep 5; 
  clear
done
