#!/bin/bash

set -e

# remove volumes
rm -rf .db

# drop existing containers
docker compose -f "docker-compose.yml" down

# prune containers
docker system prune --force

docker-compose -f "docker-compose.yml" up -d \
    --remove-orphans \
    --force-recreate \
    --build mongo1

M1_OPTS="--tls --tlsCAFile /data/ssl/ca.pem --tlsCertificateKeyFile /data/ssl/server.pem --tlsAllowInvalidCertificates"
docker-compose -f "docker-compose.yml" exec -T mongo1 /scripts/wait-for-mongodb.sh "mongo1:27017" "$M1_OPTS"

echo "Creating replica set..."
docker-compose -f "docker-compose.yml" exec -T mongo1 /scripts/init.sh