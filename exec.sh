#!/bin/bash

# build docker image from current setup usefor rebuild (e.g. changes in bin folder)
docker build $@ . -t robotframework

# execute test
# -ti is to enable keyboard interaction (CTRL-C) in the running container
# -v mounts the volumes, one for reports the other one for the actual robotframework tests
# -e set environment variable configuration ... the browser ...
docker run -ti -v `pwd`/reports:/opt/robotframework/reports:Z -v `pwd`/test:/opt/robotframework/tests:Z -e BROWSER=chrome robotframework
