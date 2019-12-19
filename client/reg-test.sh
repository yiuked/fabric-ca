#!/bin/bash

export FABRIC_CA_CLIENT_HOME=/home/vagrant/fabric-ca/client

ORDERER_DIR=${FABRIC_CA_CLIENT_HOME}/crypto-config/ordererOrganizations/36sn.com
PEER_DIR=${FABRIC_CA_CLIENT_HOME}/crypto-config/peerOrganizations/org1.36sn.com

mkdir -p $ORDERER_DIR/ca
mkdir -p $ORDERER_DIR/msp
mkdir -p $ORDERER_DIR/msp/admincerts
mkdir -p $ORDERER_DIR/msp/cacerts
mkdir -p $ORDERER_DIR/msp/tlscacerts
mkdir -p $ORDERER_DIR/orderers
mkdir -p $ORDERER_DIR/tlsca
mkdir -p $ORDERER_DIR/users

set -x
${FABRIC_CA_CLIENT_HOME}/fabric-ca-client register --id.type orderer --id.name orderer.36sn.com --id.secret 123456 --id.affiliation 36sn.com --id.attrs '"hf.Registrar.Roles=orderer","hf.Revoker=true"'
res=$?
set +x
if [ $res -ne 0 ]; then
    echo "Failed to register ..."
    exit 1
fi
echo 

set -x
${FABRIC_CA_CLIENT_HOME}/fabric-ca-client enroll -u http://admin:admin@localhost:7054 -M $ORDERER_DIR/orderers/orderer.36sn.com/msp
set +x
echo

set -x
${FABRIC_CA_CLIENT_HOME}/fabric-ca-client register --id.type client --id.name Admin@36sn.com --id.secret 123456 --id.affiliation 36sn.com --id.attrs '"hf.Registrar.Roles=orderer,admin,client","hf.Revoker=true"'
res=$?
set +x
if [ $res -ne 0 ]; then
    echo "Failed to register ..."
    exit 1
fi
echo 

set -x
${FABRIC_CA_CLIENT_HOME}/fabric-ca-client enroll -u http://admin:admin@localhost:7054 -M $ORDERER_DIR/users/Admin@36sn.com/msp
set +x
echo

cp $ORDERER_DIR/orderers/orderer.36sn.com/msp/cacerts/*.pem $ORDERER_DIR/ca
cp $ORDERER_DIR/orderers/orderer.36sn.com/msp/cacerts/*.pem $ORDERER_DIR/tlsca
cp $ORDERER_DIR/orderers/orderer.36sn.com/msp/cacerts/*.pem $ORDERER_DIR/msp/cacerts
cp $ORDERER_DIR/orderers/orderer.36sn.com/msp/cacerts/*.pem $ORDERER_DIR/msp/tlscacerts
mkdir -p cp $ORDERER_DIR/orderers/orderer.36sn.com/tls
cp $ORDERER_DIR/orderers/orderer.36sn.com/msp/cacerts/*.pem $ORDERER_DIR/orderers/orderer.36sn.com/tls/ca.crt
cp $ORDERER_DIR/orderers/orderer.36sn.com/msp/signcerts/*.pem $ORDERER_DIR/orderers/orderer.36sn.com/tls/server.crt
cp $ORDERER_DIR/orderers/orderer.36sn.com/msp/keystore/*_sk $ORDERER_DIR/orderers/orderer.36sn.com/tls/server.key
mkdir -p cp $ORDERER_DIR/users/Admin@36sn.com/tls
cp $ORDERER_DIR/users/Admin@36sn.com/msp/cacerts/*.pem $ORDERER_DIR/users/Admin@36sn.com/tls/ca.crt
cp $ORDERER_DIR/users/Admin@36sn.com/msp/signcerts/*.pem $ORDERER_DIR/users/Admin@36sn.com/tls/server.crt
cp $ORDERER_DIR/users/Admin@36sn.com/msp/keystore/*_sk $ORDERER_DIR/users/Admin@36sn.com/tls/server.key

mkdir -p $PEER_DIR/ca
mkdir -p $PEER_DIR/msp
mkdir -p $PEER_DIR/msp/admincerts
mkdir -p $PEER_DIR/msp/cacerts
mkdir -p $PEER_DIR/msp/tlscacerts
mkdir -p $PEER_DIR/peers
mkdir -p $PEER_DIR/tlsca
mkdir -p $PEER_DIR/users

set -x
${FABRIC_CA_CLIENT_HOME}/fabric-ca-client register --id.type peer --id.name peer0.org1.36sn.com --id.secret 123456 --id.affiliation org1.36sn.com --id.attrs '"hf.Registrar.Roles=peer,user","hf.Revoker=true"'
res=$?
set +x
if [ $res -ne 0 ]; then
    echo "Failed to register ..."
    exit 1
fi
echo 

set -x
${FABRIC_CA_CLIENT_HOME}/fabric-ca-client enroll -u http://admin:admin@localhost:7054 -M $PEER_DIR/peers/peer0.org1.36sn.com/msp
set +x
echo

set -x
${FABRIC_CA_CLIENT_HOME}/fabric-ca-client register --id.type client --id.name Admin@org1.36sn.com --id.secret 123456 --id.affiliation org1.36sn.com --id.attrs '"hf.Registrar.Roles=peer,admin,user,client","hf.Revoker=true"'
res=$?
set +x
if [ $res -ne 0 ]; then
    echo "Failed to register ..."
    exit 1
fi
echo 

set -x
${FABRIC_CA_CLIENT_HOME}/fabric-ca-client enroll -u http://admin:admin@localhost:7054 -M $PEER_DIR/users/Admin@org1.36sn.com/msp
set +x
echo

cp $PEER_DIR/peers/peer0.org1.36sn.com/msp/cacerts/*.pem $PEER_DIR/ca
cp $PEER_DIR/peers/peer0.org1.36sn.com/msp/cacerts/*.pem $PEER_DIR/tlsca
cp $PEER_DIR/peers/peer0.org1.36sn.com/msp/cacerts/*.pem $PEER_DIR/msp/cacerts
cp $PEER_DIR/peers/peer0.org1.36sn.com/msp/cacerts/*.pem $PEER_DIR/msp/tlscacerts
mkdir -p cp $PEER_DIR/peers/peer0.org1.36sn.com/tls
cp $PEER_DIR/peers/peer0.org1.36sn.com/msp/cacerts/*.pem $PEER_DIR/peers/peer0.org1.36sn.com/tls/ca.crt
cp $PEER_DIR/peers/peer0.org1.36sn.com/msp/signcerts/*.pem $PEER_DIR/peers/peer0.org1.36sn.com/tls/server.crt
cp $PEER_DIR/peers/peer0.org1.36sn.com/msp/keystore/*_sk $PEER_DIR/peers/peer0.org1.36sn.com/tls/server.key
mkdir -p cp $PEER_DIR/users/Admin@org1.36sn.com/tls
cp $PEER_DIR/users/Admin@org1.36sn.com/msp/cacerts/*.pem $PEER_DIR/users/Admin@org1.36sn.com/tls/ca.crt
cp $PEER_DIR/users/Admin@org1.36sn.com/msp/signcerts/*.pem $PEER_DIR/users/Admin@org1.36sn.com/tls/server.crt
cp $PEER_DIR/users/Admin@org1.36sn.com/msp/keystore/*_sk $PEER_DIR/users/Admin@org1.36sn.com/tls/server.key
