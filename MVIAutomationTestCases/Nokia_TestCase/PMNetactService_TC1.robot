*** Settings ***
Library      SSHLibrary
Resource    ../Resource/pmresources.robot
Variables    ../Resource/parameters.yaml
Library    String    
Library    Collections    
Suite Setup            Open SSH Connection And Login To Server  ${clab689_info.host_ip}  ${clab689_info.user_name}  ${clab689_info.password}
Suite Teardown         Close All Connections  
*** Test Cases ***
PMNetactService_TC1
    [Documentation]    NetAct Service Verification
    [Tags]    TC_1
    Write  sudo su -   
    Read    delay=1s    
    Write   ${netactpm_cmd}   
    ${output}=  Read    delay=15s 
    
    @{split_list}=    Create List     
     #Log To Console         ${output}
    @{str1}=  Split To Lines  ${output}  0  -1 
    
    @{split_list}=    Create List     
    # #${count}=    Get Length    ${str1}
    # #Log To Console  ${count}
    :FOR  ${j}  IN  @{str1}
   #\    ${res}=  Strip String  ${j}
    \    ${split_str}=    Remove String Using Regexp  ${j}  ([^a-z0-9_]|31m|01)
        
    \   Append To List  ${split_list}  ${split_str}    
     @{result_list}=  Create List    
     :FOR    ${cmdintre_value}  IN    @{split_list}
     
    \    ${v2}=    Run Keyword And Return Status    Should Contain  ${cmdintre_value}  started
    \     Run Keyword If   ${v2}  Log  NASDA Object ${cmdintre_value} avaialable 
     \     ...    ELSE  Append To List  ${result_list}  ${cmdintre_value}
     ${result_count}=  Get Length    ${result_list}
     Run Keyword If  ${result_count}==0    Pass Execution  NASDA Objects are available
     ...    ELSE  Fail  NASDA Objects ${result_list} are not available
     
    
            
    