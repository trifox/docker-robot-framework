*** Settings ***
Documentation     example make google page screenshot
Resource          level1/level2/level3/resource.robot
Library           SeleniumLibrary

*** Variables ***
${BROWSER}        %{BROWSER}

*** Test Cases ***
Visit Google
    [Documentation]    open browser and make screenshot
    Open Browser    http://www.google.com    ${BROWSER}
    Capture Page Screenshot    google.png
    Close Browser
    Test Keyword
