*** Settings ***
Library    SeleniumLibrary 
Resource    ../Resource/fmresources.robot 
Resource    ../Resource/fmlocators.robot
Variables   ../Resource/parameters.yaml
     

*** Test Cases ***
FMOIBVerification_TC10
    Open Browser To Login Netact Page
    #Sleep    3    
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${accept_btn}
    #Sleep    3
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${userassist_tab}
    Wait Until Keyword Succeeds	100s	10s  Click Element  ${oib_ele}
    Select Window  locator=NEW   
    # ${get_title}=  Get Title  
    
    # #Wait Until Keyword Succeeds	100s	10s  Switch Window    Object Information Browser - CLAB689 - naresh
    # Wait Until Keyword Succeeds	100s	10s  Select Window     ${get_title}
      
    Wait Until Keyword Succeeds	100s	10s  Mouse Over      ${alarm_mouse}    
    Wait Until Keyword Succeeds	100s	10s  Double Click Element   ${alarm_mouse}
    Sleep    5   
    Press Keys  ${input_ele}  A+BACKSPACE 
    #Sleep  5
    Input Text    ${input_ele}    PCF FM adaptation (com.nokia.pcf)
    Sleep  2
    Press Keys  ${input_ele}  ENTER        
    Wait Until Keyword Succeeds	100s	10s  Execute Javascript    window.scrollTo(0,document.body.scrollHeight)
    Capture Page Screenshot     FM_TC10_1.png
    sleep  2
    ${get_value}=  Get Text    //td[contains(text(),'Results:')]
    ${result_text}=    Run Keyword And Return Status    Should not Contain     ${get_value}   Results: 0  
    Run Keyword If    ${result_text}    Log  Alarms for ${oib_alarm.oib_alarm} will be visible in the OIB        
    ...    ELSE  fail    Alarms for ${oib_alarm.oib_alarm} will be not visible in the OIB  
    
    Close Browser
     
     
                  