#!/bin/bash

START_DATE=$(date)
echo "[INFO] Documentation Start ${START_DATE}"

echo "[INFO] Tydiing sourcecode in place recursive"
# code tidy is included in reporting step (for now) and helps syntax parsing
python -m robot.tidy -recursive --lineseparator unix /opt/robotframework/tests

echo "[INFO] Tydiing sourcecode finished
"
# enable filename double star ** globbing using globstar shell extension

echo "[INFO] Creating test Resource documentation"
shopt -s globstar
mkdir ${REPORTDIR}/doc
INDEX=0
for file in ${TESTDIR}/**/*.{robot,txt}
do

  RELATIVE=${file//${TESTDIR}\//}
  RELATIVE2=${file//\//_}
  echo "Eventual Resource File: ${INDEX}-${RELATIVE2}"
  python -m robot.libdoc $file ${REPORTDIR}/doc/${RELATIVE2}.html
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
echo "[INFO] Creating Library documentation"
mkdir ${REPORTDIR}/doc/library
# Create Library Documentation from the bundled libraries
python -m robot.libdoc SeleniumLibrary ${REPORTDIR}/doc/library/SeleniumLibrary.html
python -m robot.libdoc CSVLibrary ${REPORTDIR}/doc/library/CSVlibrary.html
python -m robot.libdoc JSONLibrary ${REPORTDIR}/doc/library/JSONLibrary.html
python -m robot.libdoc JSONSchemaLibrary ${REPORTDIR}/doc/library/JSONSchemaLibrary.html
python -m robot.libdoc JSONSchemaLibrary ${REPORTDIR}/doc/library/JSONSchemaLibrary.html
python -m robot.libdoc MongoDBLibrary ${REPORTDIR}/doc/library/MongoDBLibrary.html
python -m robot.libdoc DatabaseLibrary ${REPORTDIR}/doc/library/DatabaseLibrary.html
python -m robot.libdoc KafkaLibrary ${REPORTDIR}/doc/library/KafkaLibrary.html
python -m robot.libdoc KafkaLibrary ${REPORTDIR}/doc/library/KafkaLibrary.html
python -m robot.libdoc AdvancedLogging ${REPORTDIR}/doc/library/AdvancedLogging.html
python -m robot.libdoc DiffLibrary ${REPORTDIR}/doc/library/DiffLibrary.html
python -m robot.libdoc StringFormat ${REPORTDIR}/doc/library/StringFormat.html
python -m robot.libdoc RandomLibrary ${REPORTDIR}/doc/library/RandomLibrary.html
python -m robot.libdoc RequestsLibrary  ${REPORTDIR}/doc/library/RequestsLibrary.html

python -m robot.libdoc ZookeeperLibrary ${REPORTDIR}/doc/library/ZookeeperLibrary.html
python -m robot.libdoc AsyncLibrary ${REPORTDIR}/doc/library/AsyncLibrary.html
python -m robot.libdoc SSHLibrary ${REPORTDIR}/doc/library/SSHLibrary.html
python -m robot.libdoc RedisLibrary ${REPORTDIR}/doc/library/RedisLibrary.html
python -m robot.libdoc ApacheTomcatManager ${REPORTDIR}/doc/library/ApacheTomcatManagerLibrary.html
python -m robot.libdoc ReactLibrary ${REPORTDIR}/doc/library/ReactLibrary.html
python -m robot.libdoc JMeterLib ${REPORTDIR}/doc/library/JMeterLibrary.html
python -m robot.libdoc FtpLibrary ${REPORTDIR}/doc/library/FtpLibrary.html
echo "[INFO] Creating Library documentation finished"

fi

END_DATE=$(date)
echo "[INFO] Documentation End ${END_DATE}"
