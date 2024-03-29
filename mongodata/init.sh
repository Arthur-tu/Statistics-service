#!/bin/bash

mongosh --tls \
  --tlsCAFile /data/ssl/ca.pem \
  --tlsCertificateKeyFile /data/ssl/server.pem <<EOF
var config = {
    "_id": "dbrs",
    "version": 1,
    "members": [
        {
            "_id": 1,
            "host": "mongo1:27017",
            "priority": 3
        }
    ]
};
rs.initiate(config, { force: true });
rs.status();
EOF