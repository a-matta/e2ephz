*** Settings ***
Library    RequestsLibrary
Library    SeleniumLibrary
Library    Collections
Library    String
Library    FakerLibrary


*** Variables ***
${BROWSER}    firefox
${SURVEY_URL}    http://localhost:3000
${DASHBOARD_URL}    http://localhost:3001
${HEART}    class:star
${FEEDBACK_AREA}    name:message
${random_string}    Generate Random String
${SEND_BUTTON}    class:surveyform_submitButton__af3z3
${THANKYOU_BUTTON}    id:fadeOut
${GOOGLE_BUTTON}    id:google-signin
${GOOGLE_LOGIN_WINDOW_TITLE_PATTERN}    *Google*
${GOOGLE_LOGIN_EMAIL_INPUT}    id:identifierId
${GOOGLE_LOGIN_EMAIL_PASSWORD}    name: password
${DASHBOARD_LANDING_PAGE}    class:header
${PROMOTER_SCORE_CALCULATION_TITLE}    xpath://div[@class='header-container']/h1




*** Keywords ***
Open Survey Form Application
    Open Browser    ${SURVEY_URL}    ${BROWSER}    survey_form
    Maximize Browser Window

Open Dashboard Application
    Open Browser    ${DASHBOARD_URL}    ${BROWSER}    dashboard
    Maximize Browser Window



Login User in Dashboard
    Switch Browser    dashboard
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
    Wait Until Element Contains    ${PROMOTER_SCORE_CALCULATION_TITLE}    Promoter Score Calculation

*** Test Cases ***
Survey Form can be submitted with message
    Open Survey Form Application
    Wait Until Element Is Visible    ${HEART}
    ${rating}=    Generate Random String    1    12345678910
    Log    ${rating}
    Click Element    xpath://div[@class='circle']//*[@value=${rating} and @class='star']
    ${lorem}=    Paragraph
    ${random}=    Generate Random String
    Log    ${lorem}
    Input Text    ${FEEDBACK_AREA}    ${lorem}
    ${input_value}=   Get Value    ${FEEDBACK_AREA}
    Sleep    3
    Set Test Variable    ${FEEDBACK_TEXT}    ${input_value}
    Log To Console    ${input_value}
    Click Button    ${SEND_BUTTON}
    Element Should Be Visible    ${THANKYOU_BUTTON}
    Sleep    4
    Open Dashboard Application
    Login User in Dashboard
    Sleep    5
    Element Should Contain    xpath://p[@class='message']    ${FEEDBACK_TEXT}
    Log To Console    ${FEEDBACK_TEXT}
    Close All Browsers
    