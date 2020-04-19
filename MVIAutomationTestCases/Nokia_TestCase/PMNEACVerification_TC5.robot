*** Settings ***
Library    SeleniumLibrary 
Resource    ../Resource/pmresources.robot   

*** Test Cases ***
LaunchBrowser and Login to app
    lanuchBrowser and login
    Sleep    3    
    Click Element    xpath://*[@id="login:legalPanelCloseButton"]
    Sleep    3 
    #click on Security tab
    Click Element    xpath://*[@id="calypso-container"]/div[2]/div/a[5]/div/span    
    Click Element    xpath://*[@id="calypso-container"]/div[2]/div/a[26]/div/span[1]    
    Sleep    5    
    Select Window    Network Element Access Control - CLAB689 - naresh
    
    Capture Page Screenshot     TC5_pcf1.png
    Input Text    xpath://input[@id='credentialList:dataTable:cneFilterBox']  com.nokia.canloc-1.0/CANLOC
    
    Press Keys    xpath://input[@id='credentialList:dataTable:cneFilterBox']  ENTER
    Sleep    10    
    Capture Page Screenshot     TC5_pcf2.png
    ${result_text}=    Run Keyword And Return Status   Element Should Be Visible   //td[@id='credentialList:dataTable:0:0:networkElementFqdn']    
              
    Run Keyword If    ${result_text}    Log To Console    pcf installed successfully       
    ...    ELSE  fail    pcf package is not listed and  needs to be installed!  
    #${text_values}  Get Text    xpath://a[@id='credentialList:dataTable:0:0:neTypeList']
    #Log To Console         ${text_values}
    #${result}=  Should Contain  ${text_values}        com.nokia.canloc-1.0/CANLOC 
    #Run Keyword If    ${result}    Log To Console    pcf installed successfully       
    #...    ELSE  Log To Console    pcf package is not listed and  needs to be installed!
    #Run Keyword And Ignore Error  Get Text    xpath://a[@id='credentialList:dataTable:0:0:neTypeList']    
          
    