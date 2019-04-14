*** Settings ***
Documentation     This TestSuite executes tests for the DatabaseLibrary and the 3 main drivers MySql,Postgres,MongoDb
Library           DatabaseLibrary
Library           MongoDBLibrary

*** Variables ***
${MYSQL_USER}     root
${MYSQL_PASSWORD}    example
${MYSQL_DB}       test
${MYSQL_HOST}     db-mysql
${MYSQL_PORT}     3306
${POSTGRES_USER}    root
${POSTGRES_PASSWORD}    example
${POSTGRES_DB}    test
${POSTGRES_HOST}    db-postgres
${POSTGRES_PORT}    5432
${MDBHost}        ufp-mongo
${MDBPort}        27017

*** Test Cases ***
Test Connect Postgres Database
    [Documentation]    Validates that the pg8000 driver is found and can be utilized to connect to a postgres db
    [Tags]    database
    Connect To Database    pg8000    ${POSTGRES_DB}    ${POSTGRES_USER}    ${POSTGRES_PASSWORD}    ${POSTGRES_HOST}    ${POSTGRES_PORT}

Test Connect Mysql Database
    [Documentation]    Validates that the pymysql driver is found and can be utilized to connect to a mysql db
    [Tags]    database
    Connect To Database    pymysql    ${MYSQL_DB}    ${MYSQL_USER}    ${MYSQL_PASSWORD}    ${MYSQL_HOST}    ${MYSQL_PORT}

Test Connect Mongo Database
    [Tags]    database    python2
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
