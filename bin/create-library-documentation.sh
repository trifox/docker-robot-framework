#!/bin/bash
source util.sh

START_DATE=$(date)
logv "[INFO] Library Documentation Start ${START_DATE}"
logvv "[INFO] Creating Library documentation"





GENERATED=${REPORTDIR}

if [ ! -d "${REPORTDIR}/doc/library" ] ; then
    # Will enter here if $DIRECTORY exists, even if it contains spaces
 mkdir ${REPORTDIR}/doc
 mkdir ${REPORTDIR}/doc/library
# Create Library Documentation from the bundled libraries
python -m robot.libdoc SeleniumLibrary ${GENERATED}/doc/library/SeleniumLibrary.html
python -m robot.libdoc CSVLibrary ${GENERATED}/doc/library/CSVlibrary.html
python -m robot.libdoc JSONLibrary ${GENERATED}/doc/library/JSONLibrary.html
python -m robot.libdoc YamlLibrary ${GENERATED}/doc/library/YamlLibrary.html
python -m robot.libdoc JSONSchemaLibrary ${GENERATED}/doc/library/JSONSchemaLibrary.html
python -m robot.libdoc MongoDBLibrary ${GENERATED}/doc/library/MongoDBLibrary.html
python -m robot.libdoc DatabaseLibrary ${GENERATED}/doc/library/DatabaseLibrary.html
python -m robot.libdoc KafkaLibrary ${GENERATED}/doc/library/KafkaLibrary.html
python -m robot.libdoc AdvancedLogging ${GENERATED}/doc/library/AdvancedLogging.html
python -m robot.libdoc DiffLibrary ${GENERATED}/doc/library/DiffLibrary.html
python -m robot.libdoc StringFormat ${GENERATED}/doc/library/StringFormat.html
python -m robot.libdoc RandomLibrary ${GENERATED}/doc/library/RandomLibrary.html
python -m robot.libdoc RequestsLibrary  ${GENERATED}/doc/library/RequestsLibrary.html
python -m robot.libdoc ZookeeperLibrary ${GENERATED}/doc/library/ZookeeperLibrary.html
python -m robot.libdoc AsyncLibrary ${GENERATED}/doc/library/AsyncLibrary.html
python -m robot.libdoc SSHLibrary ${GENERATED}/doc/library/SSHLibrary.html
python -m robot.libdoc RedisLibrary ${GENERATED}/doc/library/RedisLibrary.html
python -m robot.libdoc ApacheTomcatManager ${GENERATED}/doc/library/ApacheTomcatManagerLibrary.html
python -m robot.libdoc ReactLibrary ${GENERATED}/doc/library/ReactLibrary.html
python -m robot.libdoc JMeterLib ${GENERATED}/doc/library/JMeterLibrary.html
python -m robot.libdoc FtpLibrary ${GENERATED}/doc/library/FtpLibrary.html
python -m robot.libdoc ImapLibrary ${GENERATED}/doc/library/ImapLibrary.html
python -m robot.libdoc FakerLibrary ${GENERATED}/doc/library/FakerLibrary.html
python -m robot.libdoc RabbitMq  ${GENERATED}/doc/library/RabbitMqLibrary.html
python -m robot.libdoc WebpackLibrary  ${GENERATED}/doc/library/WebpackLibrary.html
python -m robot.libdoc WebSocketClient  ${GENERATED}/doc/library/WebsocketClientLibrary.html
else
logvv "Re-Using existing documentation"
fi


logvv "[INFO] Creating Library documentation finished"

END_DATE=$(date)
logv "[INFO] Library Documentation End ${END_DATE}"
