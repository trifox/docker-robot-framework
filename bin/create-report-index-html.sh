#!/bin/bash
source util.sh

START_DATE=$(date)
logv "[INFO] Index Html Report Start ${START_DATE}"

# code tidy is included in reporting step (for now) and helps syntax parsing


if [ "${LOG_LEVEL}" = "vvv" ]
then
    logvv "[INFO] Tidy up source code"
    python -m robot.tidy -recursive -l unix /opt/robotframework/tests
    logvv "[INFO] Tidy up source code finished"
fi

# enable filename double star ** globbing using globstar shell extension
shopt -s globstar

HTML=" "
INDEX=0

logvv "[INFO] ReportDir is :${REPORTDIR} "
HTML="${HTML}
<nav class='navbar navbar-expand-lg navbar-light navbar-light bg-light justify-content-between'>

 <a href='https://froso.de'>
<img  style='height:1.9em;' src='data:image/png;base64,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' /></a>


            <a class='navbar-brand  ' href='#' target='_self'>UFP RobotFramework Test Report</a>
 <a href='https://froso.de'>
<img style='height:1.9em;' src='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAABmJLR0QA/wD/AP+gvaeTAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4gwSEzcZQrR34QAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUHAAACBUlEQVR42u3dsS4EURSA4bMbrYRCQkQhsRKaDYWokGhEuUoewSrVSqL0HLTbKRQSW9IhUYlChEKhMp7AFByM3e97gBuZ8yd3M7nj1iIOi+BXHB2txvb23LfX6XTuYn39OOVvqhtLfxOAABAAAkAACAABIAAEgAAQAAJAAAgAASAAes9A1kL7+0uxuDjmiZaYmhpOWacoiuoF0GyOxPLyhCn/glqtZgtAAAgAASAABIAA+NMACh+Y9XcAie8msAUgAASAABAAAkAA/Iy0AyFZL4K63YfodO5MpsTNzUv1Ash6EXRx8RB7e+embAtAAAgAASAABIAAEAACQAAIAAEgAASAABAAX5R2IOT9PedI0Pj4YKys+FczZZ6e3uLq6rFaAdTrOUeCWq1GtFoNUy7h2jj8BkAACAABIAAEgAAQAAJAAAgAASAABIAAEACfSjsRtLt7FgcHXU+0RLs9n3LaqZLXxmWdUetlGxvTKeu4Ng4BIAAEgAAQAAJAAAgAASAABIAAEAACQACUSTsQsrk5G43GkCdaYmFhtHcD2NqaibW1SVO2BSAABIAAEAACQAD0QQCJXyvxHwNI/FoJWwACQAAIAAEgAATAz6jctXH3969xe/tsMiUuLx+rF0DWtXEnJ9exs3NqyrYABIAAEAACQAAIAAEgAASAABAAAkAACAABIAC+4gONnkzAHNVWPgAAAABJRU5ErkJggg==' alt=''></a>



        </nav>
<div class='card'>
<div class='card-body'>
<h5  class='card-title'> Robot Framework Test Report</h5>
<a href='report.html' class='btn btn-primary'>Test Report</a>
<a href='log.html' class='btn btn-secondary'>Test Log</a>
</div>
</div>"


if [ "${LOG_LEVEL}" = "vv" ]||[ "${LOG_LEVEL}" = "vvv" ]
then
HTML="${HTML}
<div class='card'>
<div class='card-body'>
<h5 class='card-title'>Test Documentation</h5>
<a href='testdoc.html' class='btn btn-info'>Test Documentation</a>
</div>
<div class='card'>
<div class='card-body'>
 <h5 class='card-title' >Test Keywords Documentation</h2>

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
<h5 class='card-title'>Reference Library</h5>

"

INDEX=0
for file in ${REPORTDIR}/doc/library/**/*.html
do

if [ -e $file ]  ;
then
  RELATIVE=${file//${REPORTDIR}\//}
  NAME=${file//${REPORTDIR}\/doc\/library\//}
  logvvv "HTML File: ${INDEX}-${RELATIVE}"
  HTML="${HTML}<a href='${RELATIVE}' class='btn btn-info'>${NAME}</a>
  "
  INDEX=$((INDEX+1))
fi
done

HTML="${HTML}
</div></div>"
fi
if [ "${LOG_LEVEL}" = "v" ]||[ "${LOG_LEVEL}" = "vv" ]||[ "${LOG_LEVEL}" = "vvv" ]
then
   HTML="${HTML}

<div class='card'>
	<div class='card-body'>
		<h5>System Logs</h5>
		<a href='chromedriver.log' class='btn btn-warning  btn-block'>chromeDriver Logs</a>
		<a href='xunit.xml' class='btn btn-warning  btn-block'>robot xunit.xml</a>
		<a href='output.xml' class='btn btn-warning  btn-block'>robot output.xml</a>
	</div>
</div>
"
fi

if [ "${LOG_LEVEL}" = "vvv" ];
then

HTML="${HTML}

<div class='card'>
	<div class='card-body'>
<h5 class='card-title'>Python update logs</h5>
<textarea class='form-control'>$(cat ${REPORTDIR}/python-update.log) </textarea>
<h5 class='card-title'>System update logs</h5>
<textarea class='form-control'>$(cat ${REPORTDIR}/system-update.log)</textarea>
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
</html>" > ${REPORTDIR}/index.html

END_DATE=$(date)
logv "[INFO] Index Html Report End ${END_DATE}"
