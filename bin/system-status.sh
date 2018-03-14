#!/bin/bash

echo "[INFO] Docker RobotFramework Status"


echo "[INFO] Status of Python packages:"
pip list --outdated  --format=columns

echo "[INFO] Status of installed system packages"
yum check-update

