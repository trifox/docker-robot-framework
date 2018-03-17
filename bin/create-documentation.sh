#!/bin/bash

START_DATE=$(date)
echo "[INFO] Documentation Start ${START_DATE}"

# code tidy is included in reporting step (for now) and helps syntax parsing
python -m robot.tidy -recursive --lineseparator unix /opt/robotframework/tests

# enable filename double star ** globbing using globstar shell extension
shopt -s globstar
mkdir ${REPORTDIR}/doc
INDEX=0
for file in ${TESTDIR}/**/*.{robot,txt}
do

  RELATIVE=${file//${TESTDIR}\//}
  RELATIVE2=${file//\//_}
  echo "Eventual Resource File: ${INDEX}-${RELATIVE2}"
  python -m robot.libdoc $file ${REPORTDIR}/doc/${RELATIVE2}.html
  INDEX=$((INDEX+1))
done

# Test Case Documentation
python -m robot.testdoc /opt/robotframework/tests ${REPORTDIR}/testdoc.html


if [ "${LOG_LEVEL}" = "vvv" ]
then
# Create Library Documentation from the bundled libraries
python -m robot.libdoc SeleniumLibrary ${REPORTDIR}/doc/SeleniumLibrary.html
python -m robot.libdoc CSVLibrary ${REPORTDIR}/doc/CSVlibrary.html
python -m robot.libdoc JSONLibrary ${REPORTDIR}/doc/JSONLibrary.html
python -m robot.libdoc JSONSchemaLibrary ${REPORTDIR}/doc/JSONSchemaLibrary.html
python -m robot.libdoc JSONSchemaLibrary ${REPORTDIR}/doc/JSONSchemaLibrary.html
python -m robot.libdoc MongoDBLibrary ${REPORTDIR}/doc/MongoDBLibrary.html
python -m robot.libdoc DatabaseLibrary ${REPORTDIR}/doc/DatabaseLibrary.html
python -m robot.libdoc KafkaLibrary ${REPORTDIR}/doc/KafkaLibrary.html
python -m robot.libdoc KafkaLibrary ${REPORTDIR}/doc/KafkaLibrary.html
python -m robot.libdoc AdvancedLogging ${REPORTDIR}/doc/AdvancedLogging.html
python -m robot.libdoc DiffLibrary ${REPORTDIR}/doc/DiffLibrary.html
python -m robot.libdoc StringFormat ${REPORTDIR}/doc/StringFormat.html
python -m robot.libdoc RandomLibrary ${REPORTDIR}/doc/RandomLibrary.html
fi
END_DATE=$(date)
echo "[INFO] Documentation End ${END_DATE}"
