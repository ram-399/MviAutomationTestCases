*** Settings ***
Library    SeleniumLibrary       

*** Keywords ***
launchBrowser
    [Arguments]  ${appurl}  ${appbrowser}
    
    Open Browser    ${appurl}   ${appbrowser} 
    Maximize Browser Window
    ${title}=    Get Title
    [Return]  ${title}   