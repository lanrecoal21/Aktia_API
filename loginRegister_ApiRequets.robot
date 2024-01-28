*** Settings ***
Documentation    API requests for login and register scenarios
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections
Library  FakerLibrary

*** Variables ***
${BASE_URL}  http://restapi.adequateshop.com

*** Test Cases ***
Register user account
     [Template]  Template for valid user registeration
     [Tags]  Lanre2
     John   testing123  200   success

Register user account with invalid requests
     [Template]  Template for invalid user registeration
     [Tags]  Lanre
     #${EMPTY}   bencqsh@example.com  testing123  400   The request is invalid
     lanre   hhardy@example.com   testing123  400   The email address you have entered is already registered

Login requests
     [Template]  Template for valid and invalid login Request
     [Tags]  Lanre3
     lanreik@examples.com  testing123   200   success
     lanreik@examples.com  testing      200   invalid username or password



*** Keywords ***
Template for valid user registeration
    [Arguments]  ${user_name}   ${user_passw}  ${status_code}  ${Res_body_text}
    Create Session    mysession    ${BASE_URL}
    ${email}=  FakerLibrary.Email
    Set Test Variable    ${email}
    ${body}=  Create Dictionary  name=${user_name}  email=${email}  password=${user_passw}
    ${header}=  Create Dictionary  Content-Type=application/json
    ${response}=  POST On Session    mysession    /api/AuthAccount/Registration  json=${body}  headers=${header}
    Status Should Be    ${status_code}

    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    ${res_body}=  Convert To String    ${response.content}
    Should Contain    ${res_body}    ${Res_body_text}

Template for invalid user registeration
    [Arguments]  ${user_name}  ${email}  ${user_passw}  ${status_code}  ${Res_body_text}
    Create Session    mysession    ${BASE_URL}
    ${body}=  Create Dictionary  name=${user_name}  email=${email}  password=${user_passw}
    ${header}=  Create Dictionary  Content-Type=application/json
    ${response}=  POST On Session   mysession    /api/AuthAccount/Registration  json=${body}  headers=${header}
    Status Should Be    ${status_code}


    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    ${res_body}=  Convert To String    ${response.content}
    Should Contain    ${res_body}    ${Res_body_text}

Template for valid and invalid login Request
    [Arguments]   ${email}  ${user_passw}  ${status_code}  ${Res_body_text}
    Create Session    mysession    ${BASE_URL}
    ${body}=  Create Dictionary  email=${email}  password=${user_passw}
    ${header}=  Create Dictionary  Content-Type=application/json
    ${response}=  POST On Session   mysession    /api/AuthAccount/Login  json=${body}  headers=${header}
    Status Should Be    ${status_code}


    Log To Console    ${response.status_code}
    Log To Console    ${response.content}

    ${res_body}=  Convert To String    ${response.content}
    Should Contain    ${res_body}    ${Res_body_text}
