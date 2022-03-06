#!/bin/bash
# Copyright (c) 2015 Boomi, Inc.

echo "unifi-prereqs-${DCP_VERSION}-catalog-centos-rhel-7.x.tar.gz"
wget -q https://storage.googleapis.com/unifi-hd-4tb/unifi-release/${DCP_VERSION}/unifi-prereqs-${DCP_VERSION}-catalog-centos-rhel-7.x.tar.gz -P /tmp

sudo tar xvf /tmp/unifi-prereqs-${DCP_VERSION}-catalog-centos-rhel-7.x.tar.gz -C /tmp > /dev/null 2>&1

sudo yum -y install java-1.8.0-openjdk-headless-1.8.0.282.b08 \
  java-1.8.0-openjdk-1.8.0.282.b08

sudo /tmp/unifi-prereqs-${DCP_VERSION}-catalog-centos-rhel-7.x/install_unifi_prereqs_catalog.sh --unifi-services-user unifi --unifi-services-group unifi

shopt -s expand_aliases
source /home/unifi/.bashrc

if [ -z "$(ls -A /usr/local/unifing-catalog-${DCP_DOT_VERSION})" ]; 
then
  echo "unifing-catalog-${DCP_DOT_VERSION}.tar.gz"
  wget -q https://storage.googleapis.com/unifi-hd-4tb/unifi-release/${DCP_VERSION}/unifing-catalog-${DCP_DOT_VERSION}.tar.gz -P /tmp
  sudo tar xvf /tmp/unifing-catalog-${DCP_DOT_VERSION}.tar.gz -C /usr/local > /dev/null 2>&1
  
  sudo chown -R unifi:unifi /usr/local/unifing-catalog-${DCP_DOT_VERSION}
  sudo chown -R unifi:unifi /usr/local/unifi_virtualenv
  
  echo "UNIFI_VIRT_ENV=/usr/local/unifi_virtualenv" >> /usr/local/unifi/unifi_env.sh
fi

sudo ln -s /usr/local/unifing-catalog-${DCP_DOT_VERSION} /usr/local/unifi
sudo ln -s /usr/local/unifing-catalog-${DCP_DOT_VERSION}/unifi_pylib/lib/unifi /usr/local/unifi_virtualenv/lib/python3.8/site-packages/

pip install /usr/local/unifi/unifi_pylib/django_celery_beat-1.4.0.Unifi-py2.py3-none-any.whl

cd /usr/local/unifi/scripts/sbin

unifi_checkdeps

if [ -z "$(ls -A /usr/local/unifing-catalog-${DCP_DOT_VERSION})" ]; 
then
  unifi_install --dbhost 127.0.0.1 --dbport 5432 --dbuser unifi \
    --dbpass unifi --dbname unifi --chost 127.0.0.1 --cport 9042 \
    --cuser cassandra --cpass cassandra --unifiuser unifi \
    --unifipass Password123! --unifiemail noreply@boomi.com \
    --unififirstname DCP --unifilastname User
fi

unifi_start
unifi_status

sleep infinity
