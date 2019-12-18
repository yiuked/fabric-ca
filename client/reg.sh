#!/bin/bash
export FABRIC_CA_CLIENT_HOME=/home/vagrant/fabric-ca/client

while getopts 'u:p:t:a:h' OPT; do
    case $OPT in
        u) USER="$OPTARG";;
        p) PASS="$OPTARG";;
        t) TYPE="$OPTARG";;
        a) AFFILIATION="$OPTARG";;
        h) PRINT_HELP=1;;
        ?) PRINT_HELP=1;;
    esac
done

if [[ $USER -eq "" ]];then
    PRINT_HELP=1
fi
if [[ $PASS -eq "" ]]; then
    PRINT_HELP=1
fi
if [[ $TYPE -eq "" ]]; then
    PRINT_HELP=1
fi
if [[ $AFFILIATION -eq "" ]]; then
    PRINT_HELP=1
fi

if [[ $PRINT_HELP -eq 1 ]]; then
    echo "Usage: `basename $0` -u -p -t -a"
    echo "    -u register user"
    echo "    -p register password"
    echo "    -t register type"
    echo "    -a register affiliation"
fi
exit
set -x
${FABRIC_CA_CLIENT_HOME}/fabric-ca-client register --id.type ${TYPE} --id.name ${USER} --id.secret ${PASS} --id.affiliation ${AFFILIATION} --id.attrs '"hf.Registrar.Roles=peer,user","hf.Revoker=true"'
res=$?
set +x
if [ $res -ne 0 ]; then
    echo "Failed to register ..."
    exit 1
fi
echo 

set -x
${FABRIC_CA_CLIENT_HOME}/fabric-ca-client enroll -u http://${USER}:${PASS}@localhost:7054 -M ${FABRIC_CA_CLIENT_HOME}/${USER}/msp
set +x
echo


#MSP
#-msp
#--admincerts       user/signcerts/cert.pem
#--cacerts          user/cacerts/cert.pem
#--keystore         user/keystore/***_sk
#--signcerts        user/signcerts/cert
#--tlscacerts       tls/tlscacerts/*.pem
#-tls
#--ca.crt          tls/tlscacerts/*.pem
#--server.crt      tls/signcerts/cert
#--server.key      tls/keystore/***_sk

mkdir -p ${FABRIC_CA_CLIENT_HOME}/${USER}/msp/tlscacerts
cp ${FABRIC_CA_CLIENT_HOME}/${USER}/msp/cacerts/*.pem ${FABRIC_CA_CLIENT_HOME}/${USER}/msp/tlscacerts

mkdir -p ${FABRIC_CA_CLIENT_HOME}/${USER}/tls
cp ${FABRIC_CA_CLIENT_HOME}/${USER}/msp/cacerts/*.pem   ${FABRIC_CA_CLIENT_HOME}/${USER}/tls/ca.crt
cp ${FABRIC_CA_CLIENT_HOME}/${USER}/msp/signcerts/*.pem ${FABRIC_CA_CLIENT_HOME}/${USER}/tls/server.crt
cp ${FABRIC_CA_CLIENT_HOME}/${USER}/msp/keystore/*_sk   ${FABRIC_CA_CLIENT_HOME}/${USER}/tls/server.key
