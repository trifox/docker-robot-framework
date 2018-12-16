*** Settings ***
Documentation     Kafka Keywords
Library           KafkaLibrary
Library           String

*** Variables ***
${HOST_KAFKA}     kafka
${PORT_KAFKA}     9092

*** Test Cases ***
Kafka Get Topics
    [Documentation]    Validates that the kafka library can be used to retrieve kafka topics
    Connect To Kafka    bootstrap_servers=${HOST_KAFKA}:${PORT_KAFKA}
    @{topics}=    Get Kafka Topics
    Close
