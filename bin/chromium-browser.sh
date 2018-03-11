#!/bin/sh
echo "[INFO] Starting wrapped chromium browser"
/usr/lib64/chromium-browser/chromium-browser-original --disable-gpu --no-sandbox $@

