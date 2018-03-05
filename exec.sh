#!/bin/bash

# build docker image from current setup
docker build --no-cache .  -t robotframework

# execute test
docker run -v `pwd`/reports:/opt/robotframework/reports:Z -v `pwd`/test:/opt/robotframework/tests:Z -e BROWSER=chrome robotframework
