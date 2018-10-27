#!/bin/sh
source util.sh
logv "[INFO] Starting wrapped chromium browser"
/usr/lib/chromium/chromium-original --disable-gpu --no-sandbox --headless --window-size=${SCREEN_WIDTH},${SCREEN_HEIGHT} $@

