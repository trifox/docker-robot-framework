#!/bin/bash

START_DATE=$(date)
echo "[INFO] Docker RobotFramework Status start ${START_DATE}"

echo "[INFO] Status of Python packages:"
PYTHON="$(pip list --outdated  --format=columns)"
echo $PYTHON
echo "$PYTHON">>$REPORTDIR/python-update.log
echo "[INFO] Status of installed system packages"
SYSTEM="$(apk info)"
echo "$SYSTEM"
echo "$SYSTEM" >> $REPORTDIR/system-update.log

END_DATE=$(date)
echo "[INFO] Docker RobotFramework Status end ${END_DATE}"
