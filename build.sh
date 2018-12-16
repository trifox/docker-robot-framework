#!/bin/bash

IMAGE_NAME="ckleinhuis/ufp-robotframework"
VERSION="13"

# build docker image from current setup usefor rebuild (e.g. changes in bin folder)
docker build $@ . -t ${IMAGE_NAME}:${VERSION} -t ${IMAGE_NAME}:latest --no-cache

echo "---------------------------------------------------------------------------------------------"
echo "Docker build finished "
echo "Docker Image name: '${IMAGE_NAME}'"
echo "Example usage of this Docker Image: "

echo ""
echo "Step 1: Create docker-compose.yml"
echo ""
cat docker-compose.yml
echo ""
echo "Step 2: execute 'docker-compose up'"
echo "---------------------------------------------------------------------------------------------"
