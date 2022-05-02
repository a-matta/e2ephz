*** Settings ***
Library    ./NpsDatabase.py
Library    OperatingSystem
Library    Collections

*** Variables ***

*** Keywords ***

*** Test Cases ***
Hello
    Get Environment Variables
    ${data}=    Survey Results
    Log To Console    ${data}
    ${keys}=    Get From Dictionary    ${data}    
    Log To Console    ${keys}
