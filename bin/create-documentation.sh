#!/bin/bash
source util.sh
START_DATE=$(date)
logv "[INFO] Documentation Start ${START_DATE}"

logvv "[INFO] Tydiing sourcecode in place recursive"
python -m robot.tidy -r -l unix /opt/robotframework/tests
logvv "[INFO] Tydiing sourcecode finished
"
logvv "[INFO] Creating test Resource documentation"
# enable filename double star ** globbing using globstar shell extension
shopt -s globstar
mkdir ${REPORTDIR}/doc
mkdir ${REPORTDIR}/doc/test
INDEX=0
for file in ${TESTDIR}/**/*.{robot,txt,tsv}
do

if [ -e $file ]  ;
then
  RELATIVE=${file//${TESTDIR}\//}
  RELATIVE2=${RELATIVE//\//_}

  logvv "Eventual Resource File: ${INDEX}-${RELATIVE2}"
  python -m robot.libdoc $file ${REPORTDIR}/doc/test/${RELATIVE2}.html

if [ $? -ne 0 ]; then
    echo "FAIL but don't worry, sometimes testcase definitions are found, or just nothin'"
fi
  INDEX=$((INDEX+1))
fi


done
logvv "[INFO] Creating test Resource documentation finished"

logvv "[INFO] Creating Test documentation"
# Test Case Documentation
python -m robot.testdoc /opt/robotframework/tests ${REPORTDIR}/testdoc.html
logvv "[INFO] Creating Test documentation finished"

if [ "${LOG_LEVEL}" = "vv" ]||[ "${LOG_LEVEL}" = "vvv" ]
then
create-library-documentation.sh
fi

END_DATE=$(date)
logv "[INFO] Documentation End ${END_DATE}"
