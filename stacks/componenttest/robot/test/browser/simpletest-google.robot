*** Settings ***
Documentation     example make google page screenshot
Library           SeleniumLibrary

*** Variables ***
${BROWSER}        chrome

*** Test Cases ***
Visit Google
    [Documentation]    open browser and make screenshot
    Open Browser    http://wiremock-rest:8080    ${BROWSER}
    Capture Page Screenshot
