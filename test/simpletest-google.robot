*** Settings ***
Library			SeleniumLibrary
Documentation    example make google page screenshot
*** Variables ***
${BROWSER}		%{BROWSER}

*** Test Cases ***
Visit Google
	[Documentation]	open browser and make screenshot
	Open Browser	http://www.google.com	${BROWSER}
	Capture Page Screenshot	google.png
    Close Browser
