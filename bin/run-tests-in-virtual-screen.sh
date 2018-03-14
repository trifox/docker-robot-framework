#!/bin/bash

echo "[INFO] Running tests in virtual screens"
echo "[INFO] Cleaning reports"
REPORTDIR=/opt/robotframework/reports
rm -rf ${REPORTDIR}/*
echo "[INFO] Linting of robot files"
rflint /opt/robotframework/tests/*
echo "[INFO] Run robot tests ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH}"
echo "[INFO] Critical Tags [${ROBOT_CRITICAL_TAG}]  "
echo "[INFO] NonCritical Tags [${ROBOT_NONCRITICAL_TAG}]  "
echo "[INFO] Includes Tags [${ROBOT_INCLUDE_TAG}]  "
echo "[INFO] Excludes Tags [${ROBOT_EXCLUDE_TAG}]  "
echo "[INFO] Log level [${ROBOT_LOGLEVEL}]  "
echo "[INFO] Other options [${ROBOT_OPTIONS}]  "
# xvfb-run --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac"

echo "[INFO] Start ${date}"

robot  -L ${ROBOT_LOGLEVEL} -i "${ROBOT_INCLUDE_TAG}"  -e "${ROBOT_EXCLUDE_TAG}"  -c "${ROBOT_CRITICAL_TAG}" -n "${ROBOT_NONCRITICAL_TAG}" --xunit xunit.xml \
	--outputDir ${REPORTDIR}  ${ROBOT_OPTIONS} /opt/robotframework/tests
# copy chromedriver logs to output


echo "[INFO] End ${date}"


if [ "${LOG_LEVEL}" = "vv" ]
then
system-status.sh
fi
echo "[INFO] Trying to copy chromedriver logs"
cp /var/log/chromedriver ${REPORTDIR}/chromedriver
#echo "[INFO] Trying to copy geckodriver logs"
#cp /var/log/geckodriver.log ${REPORTDIR}/geckodriver.log

