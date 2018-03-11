#!/bin/sh
echo "[INFO] Starting wrapped chromedriver"
/usr/bin/chromedriver --verbose --log-path=/var/log/chromedriver --no-sandbox $@

