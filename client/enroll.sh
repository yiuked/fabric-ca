#!/bin/bash

export FABRIC_CA_CLIENT_HOME=/home/vagrant/fabric-ca/client/ca-files

echo -n "Enter user:"
read USER
echo -n "Enter pass:"
read PASS

HTTP="http"
TLS=""

for i in "$*"; do
    case $i in
      --tls)
      HTTP="https"
      TLS="--tls.certfiles=${FABRIC_CA_CLIENT_HOME}/msp/cacerts/localhost-7054.pem"
      ;;
    esac
done

set -x
./fabric-ca-client enroll -u ${HTTP}://${USER}:${PASS}@localhost:7054 -M ${FABRIC_CA_CLIENT_HOME}/${USER} ${TLS}
res=$?
set +x

if [ $res -ne 0 ];then
    rm -rf ${FABRIC_CA_CLIENT_HOME}/fabric-ca-client-config.yaml ${FABRIC_CA_CLIENT_HOME}/admin/
fi
