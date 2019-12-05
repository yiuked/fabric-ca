#!/bin/bash

CLIENT_HOME=/home/vagrant/fabric-ca/client

export FABRIC_CA_CLIENT_HOME=${CLIENT_HOME}/ca-files

echo -n "Enter user:"
read USER
echo -n "Enter pass:"
read PASS
echo -n "Enter type(client,orderer,peer,user):"
read TYPE
echo -n "Enter affiliation:"
read AFFILIATION

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
${CLIENT_HOME}/fabric-ca-client enroll -u http://${USER}:${PASS}@localhost:7054 -M ${FABRIC_CA_CLIENT_HOME}/${AFFILIATION}/users/${USER}
set +x
echo 
