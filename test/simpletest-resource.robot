*** Settings ***
Documentation     example make google page screenshot
Library           SeleniumLibrary

*** Variables ***
${BROWSER}        %{BROWSER}

*** Keywords ***
Visit Google
    [Documentation]    open browser and make screenshot
    Open Browser    http://www.google.com    ${BROWSER}
    Capture Page Screenshot    google.png
    Close Browser
