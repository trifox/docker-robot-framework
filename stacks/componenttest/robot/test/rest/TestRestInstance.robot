*** Settings ***
Library           REST    http://wiremock-rest:8080

*** Test Cases ***
Get one user and output what we call an instance
    GET    /__admin
    Output
    Output schema    response body
    Object    response body    # values are fully optional
