*** Settings ***
Documentation     This test assumes that the infra and debug stack is running.Since this is a SIDT template we believe the debug setup ist part of the provided value hence testing the debug frontend is part of the job
Library           SeleniumLibrary

*** Variables ***
${SERVICE_NAME1}    development-overview
${SERVICE_PORT1}    3000
${SERVICE_NAME2}    phpmyadmin
${SERVICE_PORT2}    80
${SERVICE_NAME3}    swagger
${SERVICE_PORT3}    8080
${SERVICE_NAME4}    web
${SERVICE_PORT4}    80

*** Test Cases ***
Test Debug Setup Index
    [Documentation]    testing develop index page
    [Tags]    debug    non-critical
    Open Browser    http://${SERVICE_NAME1}:${SERVICE_PORT1}    Chrome
    Wait Until Page Contains    UFP-SIDT
    Capture Page Screenshot    ScreenshotDebugEntryPoint.png

Test Debug Setup Swagger
    [Documentation]    testing swagger gui is reachable
    [Tags]    debug    non-critical
    Open Browser    http://${SERVICE_NAME3}:${SERVICE_PORT3}    Chrome
    Wait Until Page Contains    swagger
    Wait Until Page Contains    /todos
    Wait Until Page Contains    /todos/{id}
    Wait Until Page Contains    /v1/swagger.json
    Capture Page Screenshot    Swagger.png
    Close Browser

Test Debug Setup PhpMyAdmin
    [Documentation]    testing phpmyadmin gui is reachable
    [Tags]    debug    non-critical
    Open Browser    http://${SERVICE_NAME2}:${SERVICE_PORT2}    Chrome
    Wait Until Page Contains    sidt-todo-app
    Capture Page Screenshot    PhpMyAdmin.png
    Close Browser
