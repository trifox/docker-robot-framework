#!/bin/bash
source util.sh
START_TIME=$SECONDS



logLogo

log "[INFO] Running tests in virtual screens"
REPORTDIR=${1:-/opt/robotframework/reports}
TESTDIR=${2:-/opt/robotframework/tests}
export REPORTDIR
export TESTDIR

#logv "[INFO] Cleaning reports"
#rm -f ${REPORTDIR}/*.*
#rm -rf ${REPORTDIR}/doc/test/*
#logv "[INFO] Cleaning reports finished"

if [ "${LOG_LEVEL}" = "vv" ] ||[ "${LOG_LEVEL}" = "vvv" ];then
    logv "[INFO] Linting of robot files"
    rflint ${TESTDIR}/*
    logv "[INFO] Linting of robot files finished"
fi

logv "[INFO] Run robot tests ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH}"
logv "[INFO] Critical Tags [${ROBOT_CRITICAL_TAG}]  "
logv "[INFO] NonCritical Tags [${ROBOT_NONCRITICAL_TAG}]  "
logv "[INFO] Includes Tags [${ROBOT_INCLUDE_TAG}]  "
logv "[INFO] Excludes Tags [${ROBOT_EXCLUDE_TAG}]  "
logv "[INFO] Log level [${ROBOT_LOGLEVEL}]  "
logv "[INFO] Other options [${ROBOT_OPTIONS}]  "
logv "[INFO] UfpRobotFramework LogLevel is  [${LOG_LEVEL}]  "
# xvfb-run --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac"


if [ "${LOG_LEVEL}" = "vv" ] ||[ "${LOG_LEVEL}" = "vvv" ]
then
create-documentation.sh
fi

START_DATE=$(date)
logv "[INFO] Start ${START_DATE}"

logStart
robot  -L ${ROBOT_LOGLEVEL} -i "${ROBOT_INCLUDE_TAG}"  -e "${ROBOT_EXCLUDE_TAG}"  -c "${ROBOT_CRITICAL_TAG}" -n "${ROBOT_NONCRITICAL_TAG}" --xunit xunit.xml --outputDir ${REPORTDIR}  ${ROBOT_OPTIONS} ${TESTDIR}
# copy chromedriver logs to output
ROBOTRESULT=$?
logEnd


END_DATE=$(date)
logv "[INFO] End ${END_DATE}"


if [ "${LOG_LEVEL}" = "vvv" ]
then
system-status.sh
fi

if [ -e /var/log/chromedriver ]
then
logv "[INFO] Trying to copy chromedriver logs"
cp /var/log/chromedriver ${REPORTDIR}/chromedriver.log
fi

create-report-index-html.sh

log "[INFO] Finished running tests in virtual screens"

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "UfpRobotDocker total duration: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"

exit $ROBOTRESULT
