#!/bin/bash

echo "[INFO] Running tests in virtual screens"
echo "[INFO] Cleaning reports"
REPORTDIR=/opt/robotframework/reports
TESTDIR=/opt/robotframework/tests
export REPORTDIR
export TESTDIR
rm ${REPORTDIR}/*
rm -rf ${REPORTDIR}/doc/test/*
echo "[INFO] Linting of robot files"
rflint ${TESTDIR}/*
echo "[INFO] Run robot tests ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH}"
echo "[INFO] Critical Tags [${ROBOT_CRITICAL_TAG}]  "
echo "[INFO] NonCritical Tags [${ROBOT_NONCRITICAL_TAG}]  "
echo "[INFO] Includes Tags [${ROBOT_INCLUDE_TAG}]  "
echo "[INFO] Excludes Tags [${ROBOT_EXCLUDE_TAG}]  "
echo "[INFO] Log level [${ROBOT_LOGLEVEL}]  "
echo "[INFO] Other options [${ROBOT_OPTIONS}]  "
echo "[INFO] UfpRobotFramework LogLevel is  [${LOG_LEVEL}]  "
# xvfb-run --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac"


if [ "${LOG_LEVEL}" = "vv" ] ||[ "${LOG_LEVEL}" = "vvv" ]
then
create-documentation.sh
fi

START_DATE=$(date)
echo "[INFO] Start ${START_DATE}"

robot  -L ${ROBOT_LOGLEVEL} -i "${ROBOT_INCLUDE_TAG}"  -e "${ROBOT_EXCLUDE_TAG}"  -c "${ROBOT_CRITICAL_TAG}" -n "${ROBOT_NONCRITICAL_TAG}" --xunit xunit.xml \
	--outputDir ${REPORTDIR}  ${ROBOT_OPTIONS} ${TESTDIR}
# copy chromedriver logs to output

END_DATE=$(date)
echo "[INFO] End ${END_DATE}"


if [ "${LOG_LEVEL}" = "vvv" ]
then
system-status.sh
fi
echo "[INFO] Trying to copy chromedriver logs"
cp /var/log/chromedriver ${REPORTDIR}/chromedriver.log

FILE=$(cat /var/log/chromedriver)

echo "<html><body><textarea>${FILE}</textarea></body><html>">> ${REPORTDIR}/chromedriver.log.html

#echo "[INFO] Trying to copy geckodriver logs"
#cp /var/log/geckodriver.log ${REPORTDIR}/geckodriver.log

create-report-index-html.sh
