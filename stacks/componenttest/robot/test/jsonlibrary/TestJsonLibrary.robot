*** Settings ***
Library           JSONLibrary.JSONLibraryKeywords

*** Test Cases ***
Test JsonLibrary
    [Tags]    python2
    ${json_obj}=    Create Dictionary    city=Bonn
    ${value}=    Get Value From Json    ${json_obj}    $.city
    Should Be Equal As Strings    ${value[0]}    Bonn
    ${json}=    Convert JSON To String    ${json_obj}
