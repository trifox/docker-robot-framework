#!/bin/bash

echo "[INFO] Running tests in virtual screens"
echo "[INFO] Cleaning reports"
REPORTDIR=/opt/robotframework/reports
rm -rf ${REPORTDIR}/*
echo "[INFO] Linting of robot files"
rflint /opt/robotframework/tests/*
echo "[INFO] Run robot tests ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH}"
xvfb-run --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" robot --loglevel TRACE	 --outputDir ${REPORTDIR} /opt/robotframework/tests
# copy chromedriver logs to output




if [ "${LOG_LEVEL}" = "vv" ]
then
system-status.sh
fi
echo "[INFO] Trying to copy chromedriver logs"
cp /var/log/chromedriver ${REPORTDIR}/chromedriver
echo "[INFO] Trying to copy geckodriver logs"
cp /var/log/geckodriver.log ${REPORTDIR}/geckodriver.log

