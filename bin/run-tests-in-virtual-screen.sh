#!/bin/bash


echo "Cleaning reports"
rm -rf /opt/robotframework/reports/*

echo "Run robot tests ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH}"
xvfb-run --server-args="-screen 0 ${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_COLOUR_DEPTH} -ac" robot --outputDir /opt/robotframework/reports /opt/robotframework/tests


