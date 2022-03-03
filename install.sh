#!/bin/bash

declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/debian_version]=apt-get

for f in ${!osInfo[@]}
do
  if [[ -f $f ]];
  then
    sudo ${osInfo[$f]} update
    sudo ${osInfo[$f]} -y install jq
    sudo ${osInfo[$f]} -y install make
    if ! $(cat ~/.bashrc | grep "alias kubectl=kubectl.exe");
    then
      echo 'alias kubectl=kubectl.exe' >> ~/.bashrc
    fi

    if ! $(cat ~/.bashrc | grep "alias docker=docker.exe");
    then
      echo 'alias docker=docker.exe' >> ~/.bashrc
    fi
  fi
done

if ! $(cat ~/.bashrc | grep "alias boomi=");
then
  echo "alias boomi=$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/boomi.sh" >> ~/.bashrc
fi
