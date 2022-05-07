*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    DateTime

*** Variables ***
${BROWSER}    chrome
${DASHBOARD_URL}    http://localhost:3001
${GOOGLE_BUTTON}    id:google-signin
${GOOGLE_LOGIN_EMAIL_INPUT}    id:identifierId
${GOOGLE_LOGIN_WINDOW_TITLE_PATTERN}    *Google*
${GOOGLE_LOGIN_EMAIL_PASSWORD}    name: password
${DASHBOARD_LANDING_PAGE}    class:header
${PROMOTER_SCORE_CALCULATION_TITLE}    xpath://div[@class='header-container']/h1
${START_DATE}    id:start
${END_DATE}    id:end
${FILTER_BUTTON}    xpath://div[contains(concat(' ', @class, ' ' ), ' datefilter-box ')]/button[text()='Filter']


*** Keywords ***
Open Dashboard Application
    Open Browser    ${DASHBOARD_URL}    ${BROWSER}    dashboard
    Maximize Browser Window


*** Test Cases ***
Login User in Dashboard
    Open Dashboard Application    
    ${window_handles}=    Get Window Handles
    #${window_identifier}=    Get Window Titles
    #Log    ${window_handles}
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
    Wait Until Element Contains    ${PROMOTER_SCORE_CALCULATION_TITLE}    Promoter Score Calculation
    #Click Element    ${START_DATE}
    Input Text    ${START_DATE}    01.01.2019
    Input Text    ${END_DATE}    31.12.2019
    Sleep    2
    Click Element    ${FILTER_BUTTON}