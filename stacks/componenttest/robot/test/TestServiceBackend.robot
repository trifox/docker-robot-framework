*** Settings ***
Documentation     This test assumes that the infra and debug stack is running.Since this is a SIDT template we believe the debug setup ist part of the provided value hence testing the debug frontend is part of the job
Test Setup        Empty Database
Library           JSONLibrary
Library           RequestsLibrary
Resource          ./Database.robot

*** Variables ***
${SERVICE_NAME1}    ufp-sidt-example-app
${SERVICE_PORT1}    3000

*** Test Cases ***
Test Service Index Todos Unhappy1
    [Documentation]    testing index of todos in browser
    [Tags]    backend    service
    ${result}=    Rest Post    http://${SERVICE_NAME1}:${SERVICE_PORT1}    /todos    {"todo"
    Should Be Equal As Strings    400    ${result.status_code}

Test Service Index Todos Unhappy2
    [Documentation]    testing index of todos in browser
    [Tags]    backend    service
    ${result}=    Rest Post    http://${SERVICE_NAME1}:${SERVICE_PORT1}    /todos    {"x" :"test"}
    Should Be Equal As Strings    400    ${result.status_code}

Test Service Index Todos Happy
    [Documentation]    testing index of todos in browser
    [Tags]    backend    service
    ${result}=    Rest Post    http://${SERVICE_NAME1}:${SERVICE_PORT1}    /todos    {"todo":"ola"}
    Should Be Equal As Strings    204    ${result.status_code}
    ${result}=    Get Items
    Should Be Equal As Strings    200    ${result.status_code}
    ${count}    Get Value From Json    ${result.json()}    $.[0].id
    ${result}=    Get Item    ${count[0]}
    ${text}    Get Value From Json    ${result.json()}    $.todo
    Should Be Equal As Strings    ola    ${text[0]}

*** Keywords ***
Get Items
    [Documentation]    get all todo items
    [Tags]    backend    service    critical
    ${result}=    Rest Get    http://${SERVICE_NAME1}:${SERVICE_PORT1}    /todos
    [Return]    ${result}

Get Item
    [Arguments]    ${itemId}
    [Documentation]    get a todo item
    [Tags]    backend    service    critical
    ${result}=    Rest Get    http://${SERVICE_NAME1}:${SERVICE_PORT1}    /todos/${itemId}
    [Return]    ${result}

Rest Post
    [Arguments]    ${protocolHostPort}    ${uri}    ${data}
    [Tags]    backend    service    critical
    Create Session    temp-name    ${protocolHostPort}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${result}=    Post Request    temp-name    ${uri}    ${data}    headers=${headers}
    Log    Response Text ${result.text}
    [Return]    ${result}

Rest Get
    [Arguments]    ${protocolHostPort}    ${uri}
    [Tags]    backend    service    critical
    Create Session    temp-name    ${protocolHostPort}
    ${result}=    Get Request    temp-name    ${uri}
    Log    Response Text ${result.text}
    [Return]    ${result}
