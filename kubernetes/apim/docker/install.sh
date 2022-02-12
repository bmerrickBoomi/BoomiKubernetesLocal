#!/bin/bash
# Copyright (c) 2015 Boomi, Inc.

wget $URL/atom/gateway_install64.sh
chmod a+x gateway_install64.sh
./gateway_install64.sh -q -Vusername=${BOOMI_USERNAME} -Vpassword=${BOOMI_PASSWORD} -VatomName=${BOOMI_ATOMNAME} \
  -VaccountId=${BOOMI_ACCOUNTID} -VenvironmentId=${BOOMI_ENVIRONMENTID} -VproxyHost=${PROXY_HOST} \
  -VproxyUser=${PROXY_USERNAME} -VproxyPassword=${PROXY_PASSWORD} -VproxyPort=${PROXY_PORT} \
  -dir ${ATOM_HOME} -VinstallToken=${INSTALL_TOKEN} > install_Gateway_${BOOMI_ATOMNAME}.log

${ATOM_HOME}/Gateway_${BOOMI_ATOMNAME}/bin/atom start
${ATOM_HOME}/Gateway_${BOOMI_ATOMNAME}/bin/atom status

sleep infinity