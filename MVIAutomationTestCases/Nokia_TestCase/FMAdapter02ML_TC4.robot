*** Settings ***
Library    SeleniumLibrary 
Resource    ../Resource/fmresources.robot
Resource    ../Resource/fmlocators.robot  

*** Test Cases ***

FMAdaptorO2MLInstallation_TC4
    [Documentation]    FMAdaptorO2MLInstallationForPcfPage
    [Tags]    TC_4
    Open Browser To Login Netact Page
    Wait Until Keyword Succeeds	100s	10s	Click Element    ${accept_btn}
    Wait Until Keyword Succeeds	100s	10s	Click Element       ${admin_tab}    
    Wait Until Keyword Succeeds	100s	10s	Click Element    ${adaption_tab}
    Wait Until Keyword Succeeds	100s	10s  Select Window    Adaptation Manager - CLAB689 - naresh
    Sleep    10
    Capture Page Screenshot    FM_TC4_1.png
    Input Text   ${inputextfield_search}   com.nokia.pcf
    Click Element    ${search_btn}
    Capture Page Screenshot    FM_TC4_2.png
    Sleep    3   #5  
    ${text_value}=  Run Keyword And Return Status   Element Should Be Visible   ${pcf_textele}         
    #${result}=    Should Contain    ${text_value}   DEPLOY         
    Log    ${text_value}   
    Run Keyword If    ${text_value}   Log  com.nokia.pcf-9.12.5.Adaptation is avaialable.       
    ...    ELSE  fail    com.nokia.pcf-9.12.5.Adaptation is not avaialable.Please install the required package            
    
    Close Browser           