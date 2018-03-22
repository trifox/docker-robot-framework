#!/bin/bash
source util.sh
START_DATE=$(date)
logv "[INFO] Documentation Start ${START_DATE}"

logvv "[INFO] Tidy up sourcecode in place recursive"
python -m robot.tidy -r -l unix /opt/robotframework/tests
logvv "[INFO] Tidy up sourcecode finished
"
logvv "[INFO] Creating test Resource documentation"
# enable filename double star ** globbing using globstar shell extension
shopt -s globstar

if [ ! -d "${REPORTDIR}/doc" ] ;
then

mkdir ${REPORTDIR}/doc
fi

if [ ! -d "${REPORTDIR}/doc/test" ] ;
then
mkdir ${REPORTDIR}/doc/test
fi

INDEX=0
for file in ${TESTDIR}/**/*.{robot,txt,tsv}
do

if [ -e $file ]  ;
then
  RELATIVE=${file//${TESTDIR}\//}
  RELATIVE2=${RELATIVE//\//_}

  logvvv "[INFO] Eventual Resource File: ${INDEX}-${RELATIVE2}"
  TEMP=$(python -m robot.libdoc $file ${REPORTDIR}/doc/test/${RELATIVE2}.html)

if [ $? -ne 0 ]; then
    logvvv "[WARNING] FAIL but don't worry, sometimes testcase definitions are found, or just nothin'"
else
    logvvv "[INFO] documented ${RELATIVE2}"
fi
  INDEX=$((INDEX+1))
fi


done
logvv "[INFO] Creating test Resource documentation finished"

logvv "[INFO] Creating Test documentation"
# Test Case Documentation
python -m robot.testdoc $TESTDIR ${REPORTDIR}/testdoc.html
logvv "[INFO] Creating Test documentation finished"

if [ "${LOG_LEVEL}" = "vv" ]||[ "${LOG_LEVEL}" = "vvv" ]
then
create-library-documentation.sh
fi

END_DATE=$(date)
logv "[INFO] Documentation End ${END_DATE}"
