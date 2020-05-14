*** Settings ***
Library    SeleniumLibrary 
Resource    ../Resource/fmresources.robot
Resource    ../Resource/fmlocators.robot    

*** Test Cases ***
NEACVerification_TC6
    [Documentation]    NEACVerification
    [Tags]    TC_6
    Open Browser To Login Netact Page  
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${accept_btn} 
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${security_tab}    
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${security_tab1}    
    Wait Until Keyword Succeeds	100s	10s  Select Window    Network Element Access Control - CLAB689 - naresh
    Sleep    10
    Capture Page Screenshot     FM_TC6_1.png
    Input Text    ${input_text_table}  com.nokia.pcf-9.12.5/PCF                           #com.nokia.canloc-1.0/CANLOC
    Sleep    10
    Press Keys    ${input_text_table}  ENTER
    Sleep    10    
    Capture Page Screenshot     FM_TC6_2.png
    ${result_text}=    Run Keyword And Return Status   Element Should Be Visible   ${vali_field}    
              
    Run Keyword If    ${result_text}    Log  com.nokia.pcf-9.12.5/PCF neac credentials are avaialable.       
    ...    ELSE  fail    com.nokia.pcf-9.12.5/PCF neac credentials are not avaialable.  
    
    Close Browser
    
    
         
    
	
       