#!/bin/bash
START_DATE=$(date)
echo "[INFO] Documentation Start ${START_DATE}"

echo "[INFO] Tydiing sourcecode in place recursive"
python -m robot.tidy -recursive --lineseparator unix /opt/robotframework/tests
echo "[INFO] Tydiing sourcecode finished
"
echo "[INFO] Creating test Resource documentation"
# enable filename double star ** globbing using globstar shell extension
shopt -s globstar
mkdir ${REPORTDIR}/doc
mkdir ${REPORTDIR}/doc/test
INDEX=0
for file in ${TESTDIR}/**/*.{robot,txt}
do
  RELATIVE=${file//${TESTDIR}\//}
  RELATIVE2=${RELATIVE//\//_}
  echo "Eventual Resource File: ${INDEX}-${RELATIVE2}"
  python -m robot.libdoc $file ${REPORTDIR}/doc/test/${RELATIVE2}.html
if [ $? -ne 0 ]; then
    echo "FAIL but don't worry, sometimes testcase definitions are found, or just nothin'"
fi
  INDEX=$((INDEX+1))
done
echo "[INFO] Creating Test Resource documentation finished"

echo "[INFO] Creating Test documentation"
# Test Case Documentation
python -m robot.testdoc /opt/robotframework/tests ${REPORTDIR}/testdoc.html
echo "[INFO] Creating Test documentation finished"

if [ "${LOG_LEVEL}" = "vv" ]||[ "${LOG_LEVEL}" = "vvv" ]
then
create-library-documentation.sh
fi

END_DATE=$(date)
echo "[INFO] Documentation End ${END_DATE}"
