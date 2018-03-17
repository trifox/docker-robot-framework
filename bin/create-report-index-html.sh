#!/bin/bash

START_DATE=$(date)
echo "[INFO] Index Html Report Start ${START_DATE}"

# code tidy is included in reporting step (for now) and helps syntax parsing
python -m robot.tidy -recursive --lineseparator unix /opt/robotframework/tests

# enable filename double star ** globbing using globstar shell extension
shopt -s globstar

HTML=" "

INDEX=0


echo "[INFO] ReportDir is :${REPORTDIR} "
HTML="${HTML}
<h2>Robot Framework Test Report</h2>
<a href='report.html' class='btn btn-primary'>Test Report</a>
<a href='log.html' class='btn btn-secondary'>Test Log</a>
<h2>Test Documentation</h2>
<a href='testdoc.html' class='btn btn-info'>Test Documentation</a>
 <h2>Reference</h2>

"

  for file in ${REPORTDIR}/doc/**/*.html
do
  RELATIVE=${file//${REPORTDIR}\//}
  echo "Eventual HTML File: ${INDEX}-${RELATIVE}"
  echo "Eventual HTML File relative: ${RELATIVE}"
  HTML="${HTML}<a href='${RELATIVE}' class='btn btn-info btn-block'>${RELATIVE}</a>"
  INDEX=$((INDEX+1))
done

if [ "${LOG_LEVEL}" = "v" ]||[ "${LOG_LEVEL}" = "vv" ]||[ "${LOG_LEVEL}" = "vvv" ]
then
   HTML="${HTML}
<h2>Chrome Driver Logs</h2>
<a href='view-source:chromedriver.log.html' class='btn btn-danger  btn-block'>chromeDriver Logs</a>
<a href='xunit.xml' class='btn btn-danger  btn-block'>robot xunit.xml</a>
<a href='output.xml' class='btn btn-danger  btn-block'>robot output.xml</a>
"

fi

echo "<html>
<head>
<link href='https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm' crossorigin='anonymous'>
<script src='https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js' integrity='sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl' crossorigin='anonymous'></script>
</head>
<body>
${HTML}
</body>
</html>" >> ${REPORTDIR}/index.html


END_DATE=$(date)
echo "[INFO] Index Html Report End ${END_DATE}"
