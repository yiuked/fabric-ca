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

TLS_DIR=${FABRIC_CA_CLIENT_HOME}/${AFFILIATION}/tls
${CLIENT_HOME}/fabric-ca-client enroll -d --enrollment.profile tls -u http://${USER}:${PASS}@localhost:7054 -M ${TLS_DIR}/${USER}


#MSP
#-admincerts       user/signcerts/cert.pem
#-cacerts          user/cacerts/cert.pem
#-keystore         user/keystore/***_sk
#-signcerts        user/signcerts/cert
#-tlscacerts       tls/tlscacerts/*.pem
#-tls
#--ca.crt          tls/tlscacerts/*.pem
#--server.crt      tls/signcerts/cert
#--server.key      tls/keystore/***_sk

MSP_DIR=${FABRIC_CA_CLIENT_HOME}/crypto-config/${TYPE}Organizations/${AFFILIATION}/${TYPE}s/${USER}
set -x
mkdir -p ${MSP_DIR}/msp
mkdir -p ${MSP_DIR}/tls

cp -r ${FABRIC_CA_CLIENT_HOME}/${AFFILIATION}/users/${USER}/* ${MSP_DIR}/msp
mkdir ${MSP_DIR}/msp/admincerts
cp ${MSP_DIR}/msp/cacerts/*.pem ${MSP_DIR}/msp/admincerts
cp -r ${TLS_DIR}/${USER}/tlscacerts ${MSP_DIR}/msp

cp ${TLS_DIR}/${USER}/tlscacerts/*.pem ${MSP_DIR}/tls/ca.crt
cp ${TLS_DIR}/${USER}/signcerts/*.pem ${MSP_DIR}/tls/server.crt
cp ${TLS_DIR}/${USER}/keystore/*_sk ${MSP_DIR}/tls/server.key
set +x

