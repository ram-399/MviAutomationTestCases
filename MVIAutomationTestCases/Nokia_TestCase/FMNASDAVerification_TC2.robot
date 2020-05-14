*** Settings ***
Library      SSHLibrary
Resource    ../Resource/fmresources.robot
Library    String 
Library    Collections  
Suite Setup            Open SSH Connection And Login To Server
Suite Teardown         Close All Connections      

*** Test Cases ***
FMNASDAVerification_TC2
     Open SSH Connection And Login To Server
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
     