#!/bin/bash
source util.sh

START_DATE=$(date)
logv "[INFO] Index Html Report Start ${START_DATE}"

# code tidy is included in reporting step (for now) and helps syntax parsing
python -m robot.tidy -r -l unix /opt/robotframework/tests

# enable filename double star ** globbing using globstar shell extension
shopt -s globstar

HTML=" "
INDEX=0

logvv "[INFO] ReportDir is :${REPORTDIR} "

HTML="${HTML}
<div class='card'>
<div class='card-body'>
<h1>UFP Report</h2>
</div>
<div class='card'>
<div class='card-body'>
<h2>Robot Framework Test Report</h2>
<a href='report.html' class='btn btn-primary'>Test Report</a>
<a href='log.html' class='btn btn-secondary'>Test Log</a>
</div>
</div>
<div class='card'>
<div class='card-body'>
<h3>Test Documentation</h3>
<a href='testdoc.html' class='btn btn-info'>Test Documentation</a>
 <h2>Test Keywords Documentation</h2>

"

for file in ${REPORTDIR}/doc/test/**/*.html
do

if [ -e $file ]  ;
then
  RELATIVE=${file//${REPORTDIR}\//}
  logvv "HTML File: ${INDEX}-${RELATIVE}"
  HTML="${HTML}<a href='${RELATIVE}' class='btn btn-info  '>${RELATIVE}</a>
  "
  INDEX=$((INDEX+1))
fi
done

HTML="${HTML}
</div></div>

<div class='card'>
<div class='card-body'>
<h2>Reference Library</h2>

"

INDEX=0
for file in ${REPORTDIR}/doc/library/**/*.html
do

if [ -e $file ]  ;
then
  RELATIVE=${file//${REPORTDIR}\//}
  NAME=${file//${REPORTDIR}\/doc\/library\//}
  logvv "HTML File: ${INDEX}-${RELATIVE}"
  HTML="${HTML}<a href='${RELATIVE}' class='btn btn-info'>${NAME}</a>
  "
  INDEX=$((INDEX+1))
fi
done

HTML="${HTML}
</div></div>"

if [ "${LOG_LEVEL}" = "v" ]||[ "${LOG_LEVEL}" = "vv" ]||[ "${LOG_LEVEL}" = "vvv" ]
then
   HTML="${HTML}

<div class='card'>
	<div class='card-body'>
		<h2>System Logs</h2>
		<a href='chromedriver.log.html' class='btn btn-danger  btn-block'>chromeDriver Logs</a>
		<a href='xunit.xml' class='btn btn-danger  btn-block'>robot xunit.xml</a>
		<a href='output.xml' class='btn btn-danger  btn-block'>robot output.xml</a>
	</div>
</div>
"
fi

if [ "${LOG_LEVEL}" = "vvv" ];
then

HTML="${HTML}

<div class='card'>
	<div class='card-body'>
<h3>Python update logs</h3>
<textarea class='form-control'>$(cat $REPORTDIR/python-update.log) </textarea>
<h3>System update logs</h3>
<textarea class='form-control'>$(cat $REPORTDIR/system-update.log)</textarea>
</div>
</div>
"
fi

echo "<html>
<head>
<link href='https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css' rel='stylesheet' integrity='sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm' crossorigin='anonymous'>
<script src='https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js' integrity='sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl' crossorigin='anonymous'></script>
</head>
<body>
${HTML}
<br/>
<br/>
<br/>
<br/>
<br/>
</body>
</html>" >> ${REPORTDIR}/index.html

END_DATE=$(date)
logv "[INFO] Index Html Report End ${END_DATE}"
