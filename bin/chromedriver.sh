#!/bin/sh
source util.sh
logv "[INFO] Starting wrapped chromedriver"
# When no logging set, dont log chrome as well
if [ "${LOG_LEVEL}" = "v" ]||[ "${LOG_LEVEL}" = "vv" ]||[ "${LOG_LEVEL}" = "vvv" ]
then
 /usr/bin/chromedriver --verbose --log-path=/var/log/chromedriver --no-sandbox --headless $@
else
 /usr/bin/chromedriver  --no-sandbox --headless $@
fi

