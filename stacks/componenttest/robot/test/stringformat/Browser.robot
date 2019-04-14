*** Settings ***
Library           StringFormat

*** Test Cases ***
Format Text
    ${url}=    Format String    https://api.domain.com/users/{0}/sites/{1}    paul    internal
    Log To Console    ${url}
