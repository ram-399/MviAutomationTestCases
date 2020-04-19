*** Settings ***
Library    SeleniumLibrary 
Resource    ../Resource/fmresources.robot   

*** Test Cases ***
LaunchBrowser and Login to app
    lanuchBrowser and login
    Sleep    3    
    Click Element    xpath://*[@id="login:legalPanelCloseButton"]
    Sleep    5  #5    
    #click on Administration
    Click Element       xpath://*[@id="calypso-container"]/div[2]/div/a[1]/div/span
    
    Click Element    xpath://span[contains(text(),'Adaptation Manager')] 
    Sleep    10  #8            
    Select Window    Adaptation Manager - CLAB689 - naresh  
    Input Text    xpath://input[@id='search']    com.nokia.pcf
    Click Element    id:searchBtn  
    Capture Page Screenshot    FM_TC4.png
    Sleep    3   #5  
    ${text_value}=  Run Keyword And Return Status   Element Should Be Visible   xpath://a[@id='adaptationListTable:0:contentIdentificationColumn']         
    #${result}=    Should Contain    ${text_value}   DEPLOY         
    Log    ${text_value}   
    Run Keyword If    ${text_value}   Log To Console    com.nokia.pcf installed successfully       
    ...    ELSE  fail    com.nokia.pcf package is not listed and  needs to be installed!             