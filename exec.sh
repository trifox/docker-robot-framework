#!/bin/bash

# build docker image from current setup usefor rebuild (e.g. changes in bin folder)
docker build $@ .  -t robotframework

# execute test
docker run -v `pwd`/reports:/opt/robotframework/reports:Z -v `pwd`/test:/opt/robotframework/tests:Z -e BROWSER=chrome robotframework
