*** Settings ***
Documentation     This Testsuite validated rest request functionality
Library           RequestsLibrary

*** Variables ***
${HOST}           http://wiremock-rest:8080
${URI}            /__admin

*** Test Cases ***
Test Rest GET
    Create Session    temp-name    ${HOST}
    ${result}=    Get Request    temp-name    ${URI}
    Log    ${result.text}
