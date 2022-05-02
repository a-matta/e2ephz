*** Settings ***
Library    RequestsLibrary
Library    SeleniumLibrary
Library    Collections
Test Setup    Open UI Application
Test Teardown    Close All Browsers 

*** Variables ***
${BROWSER}    chrome
${BASE_URL}    http://localhost:3000
${GOOGLE_BUTTON}    id:google-signin
${GOOGLE_LOGIN_WINDOW_TITLE_PATTERN}    *Google*
${GOOGLE_LOGIN_EMAIL_INPUT}    id:identifierId
${GOOGLE_LOGIN_EMAIL_PASSWORD}    name: password
${DASHBOARD_LANDING_PAGE}    class:header

*** Keywords ***
Open UI Application
    Open Browser    ${BASE_URL}    ${BROWSER}

Window Count
    ${window_titles}=    Get Window Titles

Window Handler
    ${handle}=    Get Window Handles
    Log    ${handle}
    ${WINDOW_HANDLER}=    Get Window Identifiers
    Log    ${WINDOW_HANDLER}
    ${WINDOW_HANDLER}=    Get Window Titles
    Log    ${WINDOW_HANDLER}
    ${WINDOW_HANDLER}=    Get Window Names
    Log    ${WINDOW_HANDLER}

Login User
    ${window_handles}=    Get Window Handles
    ${window_identifier}=    Get Window Titles
    Log    ${window_handles}
    ${main_app_handle}=    Get From List    ${window_handles}    0
    Click Element    ${GOOGLE_BUTTON}
    WHILE    True    limit=5
        ${window_titles}=    Get Window Titles
        ${match_count}=    Get Match Count    ${window_titles}    ${GOOGLE_LOGIN_WINDOW_TITLE_PATTERN}
        Log    ${window_titles}
        Log    ${match_count}
        Run Keyword If    '${match_count}'>'1'    Fail    Too many Browser Tabs found that meet the "${GOOGLE_LOGIN_WINDOW_TITLE_PATTERN}" pattern.
        IF    '${match_count}'=='1'
            BREAK
        END
        Sleep    1
    END
    ${matches}    Get Matches    ${window_titles}    ${GOOGLE_LOGIN_WINDOW_TITLE_PATTERN}
    Log    ${matches}
    Switch Window    ${matches}[0]
    Input Text    ${GOOGLE_LOGIN_EMAIL_INPUT}    npstestglory@gmail.com
    Press Keys    ${GOOGLE_LOGIN_EMAIL_INPUT}    RETURN
    
    WHILE    True    limit=5
        ${count}=    Get Element Count   ${GOOGLE_LOGIN_EMAIL_PASSWORD}
        Log    ${count}
        IF    '${count}'!='0'
            BREAK
        END
        Sleep    1
    END
    Input Text    ${GOOGLE_LOGIN_EMAIL_PASSWORD}    aR7FsedNirgrM2K
    Press Keys    ${GOOGLE_LOGIN_EMAIL_PASSWORD}    RETURN
    Switch Window    ${main_app_handle}
    Sleep    5
    Wait Until Element Contains    xpath://*[contains(concat(' ', @class, ' '), ' header ')]    Net Promoter Score Calculation
    
*** Test Cases ***
Login with Google credentials
    Login User
