*** Settings ***
Documentation     example make google page screenshot
Library           SeleniumLibrary

*** Variables ***
${BROWSER}        chrome

*** Test Cases ***
Visit Google
    [Documentation]    open browser and make screenshot
    Open Browser    http://wiremock-rest:8080/__admin    ${BROWSER}
    Capture Page Screenshot

Test Badly signed https certificate
    [Documentation]    open browser and make screenshot
    Open Browser    https://self-signed.badssl.com/    ${BROWSER}    –-ignore-certificate-errors
    Wait until page Contains    self-signed
    Capture Page Screenshot
