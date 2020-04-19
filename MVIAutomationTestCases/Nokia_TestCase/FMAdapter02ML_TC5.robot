** Settings ***
Library    SeleniumLibrary 
Resource    ../Resource/fmresources.robot   

*** Test Cases ***
LaunchBrowser and Login to app
    lanuchBrowser and login
    Sleep    3    
    Click Element    xpath://*[@id="login:legalPanelCloseButton"]
    Sleep    5    
    #click on Administration
    Click Element       xpath://*[@id="calypso-container"]/div[2]/div/a[1]/div/span
    
    Click Element    xpath://span[contains(text(),'Adaptation Manager')] 
    Sleep    8             
    Select Window    Adaptation Manager - CLAB689 - naresh 
    Input Text    xpath://input[@id='search']    com.nokia.pcf.man
    Click Element    id:searchBtn  
    Sleep    5  
    #${textoutput}    Get Text    xpath://tbody[@id='adaptationListTable:tb']//*[@id="adaptationListTable:0:StateColumn"]//span[@id='adaptationListTable:0:contentStatusColumn'] 
    ${result_text}=    Run Keyword And Return Status   Element Should Be Visible   xpath://tbody[@id='adaptationListTable:tb']//*[@id="adaptationListTable:0:StateColumn"]//span[@id='adaptationListTable:0:contentStatusColumn']    
              
    Run Keyword If    ${result_text}    Log To Console    com.nokia.pcf.man package is  installed successfully!       
    ...    ELSE  fail    com.nokia.pcf.man package is not listed and it  needs to be installed!        
    #Element Text Should Be    xpath://tbody[@id='adaptationListTable:tb']//*[@id="adaptationListTable:0:StateColumn"]//span[@id='adaptationListTable:0:contentStatusColumn']    DEPLOYED 
                
                   
