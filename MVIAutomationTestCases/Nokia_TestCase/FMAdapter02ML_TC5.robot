** Settings ***
Library    SeleniumLibrary 
Resource    ../Resource/fmresources.robot
Resource    ../Resource/fmlocators.robot   

*** Test Cases ***
FMAdaptorO2MLInstallationforManPage_TC5
    [Documentation]    FMAdaptorO2MLInstallationForManPage
    [Tags]    TC_5
    Open Browser To Login Netact Page
    Sleep    3    
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${accept_btn}
    Wait Until Keyword Succeeds	100s	10s  Click Element       ${admin_tab}
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${adaption_tab}          
    Wait Until Keyword Succeeds	100s	10s  Select Window    Adaptation Manager - CLAB689 - naresh
    Sleep    10
    Capture Page Screenshot    FM_TC5_1.png 
    Input Text    ${inputextfield_search}    com.nokia.pcf.man
    Click Element    ${search_btn}
    Sleep    5
    Capture Page Screenshot    FM_TC5_2.png 
    Sleep    2 
    #${textoutput}    Get Text    xpath://tbody[@id='adaptationListTable:tb']//*[@id="adaptationListTable:0:StateColumn"]//span[@id='adaptationListTable:0:contentStatusColumn'] 
    ${result_text}=    Run Keyword And Return Status   Element Should Be Visible   ${pcfman_textele}    
              
    Run Keyword If    ${result_text}    Log    com.nokia.pcf.man-9.12.5.Adaptation is avaialable.       
    ...    ELSE  fail    com.nokia.pcf.man-9.12.5.Adaptation is not avaialable.Please install the required package 
    Close Browser 
