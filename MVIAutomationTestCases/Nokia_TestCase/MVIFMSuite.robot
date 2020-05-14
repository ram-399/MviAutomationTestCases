*** Settings ***
Library    SeleniumLibrary 
Library    SSHLibrary 
Library    String
Library    Collections        
Resource   ../Resource/fmresources.robot 
Resource   ../Resource/fmlocators.robot 
Suite Setup    Run KeyWords
...            Open SSH Connection And Login To Server

Suite Teardown  Run KeyWords
...             Close All Connections    AND
...             Close All Browsers       

*** Test Cases ***
FMNetactService_TC1
    [Documentation]    FMNetactServiceVerification
    [Tags]    TC_1
    Open SSH Connection And Login To Server
    Sleep    2    
    ${output}=         Execute Command    /opt/cpf/sbin/netact_status.sh status | grep started
    @{split_list}=    Create List   
    ${stopped_services}=    Execute Command   /opt/cpf/sbin/netact_status.sh status | grep -v started 
   
    @{str1}=    Split To Lines  ${stopped_services}    3
    :FOR  ${j}  IN  @{str1}
    \    ${res}=  Strip String  ${j}
    \    ${split_str}=    Remove String Using Regexp  ${res}  ^[\s]?clab[0-9a-z]*
    \    ${length}=  Get Length    ${split_str}
    \    Run Keyword if  ${length} != 0\    Append To List  ${split_list}  ${split_str} 
     Log List    ${split_list}
      #${result}=    Run Keyword And Return Status    Should Contain    ${output}    stopped 
     Log List    ${split_list} 
     ${length1}=  Get Length    ${split_list}
     Run Keyword If  ${length1}==0  log  All Services are running Successfully.
     ...    ELSE    Fail    Services are not started and stopped servive\(s\) ${split_list} 
    
  
NASDA_Service_TC2
     [Documentation]    NASDAServiceVerification
     [Tags]    TC_2
     ${PCF_output1}=  Execute Command    ${cmdcor}    
     Sleep  5
     ${PCF_output2}=    Execute Command    ${cmdint}    
     @{list_1}=  Create List
     @{output}=  Split To Lines  ${PCF_output2}
     :FOR  ${i}  IN  @{output}
     \  ${stp_string}=    Strip String  ${i}    
     \   Append To List  ${list_1}   ${stp_string}
     @{fin_list}=    Create List
     :FOR  ${k}  IN  @{list_1}
     \    ${match}=    Should Match Regexp  ${k}  "CHILD_[A-Z]*"
     \    ${reqop}=  Remove String Using Regexp   ${match}  CHILD_
     \    ${rmv_qua}=  Remove String    ${reqop}    "
     \    Append To List  ${fin_list}  ${rmv_qua}
 
     ${result1}=    Run Keyword And Return Status    Should Contain    ${PCF_output1}    CHILD_PCF    
     @{result_list}=    Create List 
    Run Keyword If    ${result1}    Log   NASDA Object PCF is available     
    ...    ELSE  Append To List  ${result_list}  CHILD_PCF
     
     @{list1}=    Create List    FTP  SNMP  SSH  HTTP1  
     :FOR    ${cmdintre_value}  IN    @{list1}
     \    ${result2}=   Run Keyword And Return Status    Should Contain  ${fin_list}       ${cmdintre_value}
     \     Run Keyword If   ${result2}  Log  NASDA Object ${cmdintre_value} avaialable 
     \     ...    ELSE  Append To List  ${result_list}  ${cmdintre_value}
     ${result_count}=  Get Length    ${result_list}
    
     Run Keyword If  ${result_count}==0    Pass Execution  NASDA Objects are available
     ...    ELSE  Fail  NASDA Objects ${result_list} are not available
     
FMAdapterMapping_TC3
     [Documentation]    FMAdapterMappingInstallation
     [Tags]    TC_3
     Open SSH Connection And Login To Server
     write    sudo su
     Read    delay=2s
     Write   ${cmd_cmnmed}
     ${output}=  Read    delay=5s
     @{str1}=    Split String    ${output}    -
     @{result}=    Split String    @{str1}[1]    ${SPACE}
    #Log To Console        @{result}[0]
     ${ssh_commed}=  Get From List  ${result}  0
     Write  ssh ${ssh_commed}
     Read    delay=1s
     Write   ${pcf_cmd}   
     ${pdf_output}=   Read    delay=17s 
     ${result}=    Run Keyword And Return Status    Should Contain    ${pdf_output}    pcf         
     Run Keyword If    ${result}    Log  Mapping file is deployed in successful state.      
     ...    ELSE  fail    Mapping file is not deployed 
                    
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