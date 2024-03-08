#!/bin/bash
NETWORKS="test development core db production"
DOCKER_NETS=$(docker network ls)

for net in $NETWORKS; do
     if [[ $DOCKER_NETS == *$net* ]]; then
        echo "Specified network $net already exists"
     else
        echo "Creating network $net"
        docker network create $net
     fi
done
