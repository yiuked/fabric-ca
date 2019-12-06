#!/bin/bash

CLIENT_HOME=/home/vagrant/fabric-ca/client

export FABRIC_CA_CLIENT_HOME=${CLIENT_HOME}/ca-files
env

USER="orderer.36sn.com"
PASS="616766"
TYPE="orderer"
AFFILIATION="org1.36sn.com"

set -x
${CLIENT_HOME}/fabric-ca-client register --id.type ${TYPE} --id.name ${USER} --id.secret ${PASS} --id.affiliation ${AFFILIATION} --id.attrs '"hf.Registrar.Roles=peer,user","hf.Revoker=true"'
res=$?
set +x
if [ $res -ne 0 ]; then
    echo "Failed to register ..."
    exit 1
fi
echo 

set -x
${CLIENT_HOME}/fabric-ca-client enroll -d --enrollment.profile tls -u http://${USER}:${PASS}@localhost:7054 -M ${FABRIC_CA_CLIENT_HOME}/${AFFILIATION}/users/${USER}
set +x
echo 
