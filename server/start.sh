#!/bin/bash

./fabric-ca-server start -b admin:admin --cfg.affiliations.allowremove --cfg.identities.allowremove -H `pwd`/ca-files
