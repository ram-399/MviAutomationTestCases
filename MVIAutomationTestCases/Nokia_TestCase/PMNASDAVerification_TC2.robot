*** Settings ***
Library      SSHLibrary
Resource    ../Resource/pmresources.robot
Library    String 
Library    Collections  
Suite Setup            Open SSH Connection And Login To Server  ${clab689_info.host_ip}  ${clab689_info.user_name}  ${clab689_info.password}
Suite Teardown         Close All Connections      


*** Test Cases ***
PMNASDAVerification_TC2
    ${IPAM_output1}=  Execute Command    ${cmdcon}
    Sleep  5
    ${IPAM_output2}=    Execute Command    ${cmdintr}        
      @{list_1}=  Create List
     @{output}=  Split To Lines  ${IPAM_output2}
     :FOR  ${i}  IN  @{output}
     \  ${stp_string}=    Strip String  ${i}    
     \   Append To List  ${list_1}   ${stp_string}
     @{fin_list}=    Create List
     :FOR  ${k}  IN  @{list_1}
     \    ${match}=    Should Match Regexp  ${k}  "CHILD_[A-Z]*"
     \    ${reqop}=  Remove String Using Regexp   ${match}  CHILD_
     \    ${rmv_qua}=  Remove String    ${reqop}    "
     \    Append To List  ${fin_list}  ${rmv_qua}
     
     @{result_list}=    Create List
     ${result1}=    Run Keyword And Return Status    Should Contain    ${IPAM_output1}    CHILD_IPAM
     Run Keyword If   ${result1}   Log  NASDA Object IPAM avaialable.        
     ...    ELSE  Append To List  CHILD_IPAM 
     
     @{list1}=    Create List    FTP  SNMP  SSH  
     :FOR    ${cmdintre_value}  IN    @{list1}
     \    ${result2}=   Run Keyword And Return Status    Should Contain  ${fin_list}       ${cmdintre_value}
     \     Run Keyword If   ${result2}  Log  NASDA Object ${cmdintre_value} avaialable 
     \     ...    ELSE  Append To List  ${result_list}  ${cmdintre_value}
     ${result_count}=  Get Length    ${result_list}
    
     Run Keyword If  ${result_count}==0    Pass Execution  NASDA Objects are available
     ...    ELSE  Fail  NASDA Objects ${result_list} are not available