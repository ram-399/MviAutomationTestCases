*** Settings ***
Library    SeleniumLibrary 
Resource    ../Resource/fmresources.robot   

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
    
    Input Text    xpath://input[@id='credentialList:dataTable:cneFilterBox']  com.nokia.pcf
    Press Keys    xpath://input[@id='credentialList:dataTable:cneFilterBox']  ENTER
    Capture Page Screenshot     TC6_pcf.png
    #${text_values}  Get Text    xpath://a[@id='credentialList:dataTable:0:0:neTypeList']
    ${result_text}=    Run Keyword And Return Status   Element Should Be Visible   xpath://a[@id='credentialList:dataTable:0:0:neTypeList']   
              
    Run Keyword If    ${result_text}    Log To Console    pcf installed successfully       
    ...    ELSE  fail    pcf package is not listed and  needs to be installed!  
    
    
         
    
	
       