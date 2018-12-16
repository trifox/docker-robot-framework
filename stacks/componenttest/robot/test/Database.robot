*** Settings ***
Documentation     Database Keywords
Library           DatabaseLibrary

*** Variables ***

${USER}    root
${PASSWORD}    root
${MYSQL_PORT}  3306

*** Keywords ***
Empty Database
     [Tags]    database
    [Documentation]  Connect to Kafka Producer
    Clear TodoApp

Clear TodoApp
     [Tags]    database
    [Documentation]  Clear Todo Database
    Connect To Database  pymysql  sidt-todo-app  ${USER}  ${PASSWORD}  todo-mysql  ${MYSQL_PORT}
    Delete All Rows From Table  todos
    Log  Table Cleared

