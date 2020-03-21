*** Settings ***

Library  RequestsLibrary
Library  HttpLibrary.HTTP
Library  Collections

*** Variables ***
${base_url}         http://localhost:8080
${endpoint}         /v1/add?
${val1}             4
${val2}             4
${properResult}     8
${improperResult}   6

*** Test Cases ***
AddValues
    Create sessions
    Check status And Content Type  ${val1}  ${val2}
    Result Should Be Equals  ${val1}  ${val2}  ${properResult}
    Result Should Not Be Equals   ${val1}  ${val2}   ${improperResult}

*** Keywords ***
Create Sessions
    create session  calculator_url  ${base_url}

Create Dictionary And Send Request
    [Arguments]     ${val1}     ${val2}
    ${params}=   Create Dictionary   val1=${val1}    val2=${val2}
    ${response}=    get request  calculator_url     ${endpoint}     params=${params}
    [Return]    ${response}

Check Status And Content Type
    [Arguments]     ${val1}     ${val2}
    ${response}=    Create Dictionary And Send Request  ${val1}     ${val2}
    Check status  ${response}
    Check content type  ${response}


Result Should Be Equals
    [Arguments]     ${val1}     ${val2}     ${result}
    ${response}=    Create Dictionary And Send Request  ${val1}     ${val2}
    ${body}=    convert to string     ${response.content}
    should contain  ${body}     ${result}

Result Should Not Be Equals
    [Arguments]     ${val1}     ${val2}     ${result}
    ${response}=    Create Dictionary And Send Request  ${val1}     ${val2}
    ${body}=    convert to string     ${response.content}
    should not contain  ${body}     ${result}

Check Content Type
    [Arguments]  ${response}
    ${contentTypeValue}=    get from dictionary  ${response.headers}     Content-Type
    should be equal     ${contentTypeValue}     application/json

Check Status
    [Arguments]  ${response}
    ${status_code}=     convert to string   ${response.status_code}
    should be equal     ${status_code}      200