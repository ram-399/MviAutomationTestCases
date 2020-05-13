*** Settings ***
Library      SSHLibrary
Library    String   
Library    Collections    
Library    OperatingSystem 
Library    Process
Variables    ../Resource/parameters.yaml
Resource    ../Resource/fmresources.robot
Library    ../Resource/NeVeSSHLib.py
 
#Variables    ../Resource/fminputfile.yaml
    
#Suite Setup   Open SSH Connection And Login To Omc User           
#Suite Teardown         Close All Connections  

*** Variables ***
${HOST}                10.32.237.58
${USERNAME}            naresh
${PASSWORD}            Nokia_12345

*** Test Cases ***
Verify the SSH ConnectionTC_1
    NeVeSSHLib.Open Ssh Connection To Host With Password  ${HOST}  ${USERNAME}  ${PASSWORD}
    Sleep    2    
    
    @{split_list}=    Create List   
    ${stopped_services}=    NeVeSSHLib.Execute Command Over Ssh Get Rc And Output  /opt/cpf/sbin/netact_status.sh status | grep -v started 
    
    @{str1}=    Split To Lines  ${stopped_services}    3
    :FOR  ${j}  IN  @{str1}
    \    ${res}=  Strip String  ${j}
    \    ${split_str}=    Remove String Using Regexp  ${res}  ^[\s]?clab[0-9a-z]*
    \    ${length}=  Get Length    ${split_str}
    \    Run Keyword if  ${length} != 0\    Append To List  ${split_list}  ${split_str} 
     Log List    ${split_list} 
     ${length1}=  Get Length    ${split_list}
     Run Keyword If  ${length1}==0  log  All Services are running Successfully.
     ...    ELSE    Fail    Services are not started and stopped servive\(s\) ${split_list}    
        
   