*** Settings ***
Library			SeleniumLibrary

*** Variables ***
${BROWSER}		%{BROWSER}

*** Test Cases ***
#Visit Google
#	Open Browser	http://www.google.com	${BROWSER}
#	Capture Page Screenshot
#
#Visit Toom.de
#	Set Selenium Implicit Wait	5 seconds
#	Open Browser	http://www.toom.de  ${BROWSER}
#	Capture Page Screenshot

Visit Toom.de and test search
	Set Selenium Implicit Wait	5 seconds
	Open Browser	http://www.toom.de  ${BROWSER}
	Click Element	class:header-search-toggle
	Capture Page Screenshot	search-clicked.png
	Input Text	search	searchword
	Capture Page Screenshot	search-input.png
	Press Key	search	\\13
	Capture Page Screenshot	search-result.png
