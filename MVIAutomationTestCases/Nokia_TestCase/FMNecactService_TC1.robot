*** Settings ***
Library      SSHLibrary
Library    String   
Library    Collections    
Variables    ../Resource/parameters.yaml
Resource     ../Resource/fmresources.robot        

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
    \    ${remove_spaces}=    Replace String Using Regexp    ${split_str}    ${SPACE*14}    |    
    \    ${length}=  Get Length    ${remove_spaces}
    \    Run Keyword if  ${length} != 0\    Append To List  ${split_list}  ${remove_spaces} 
   
     Log List    ${split_list}
    
      #${result}=    Run Keyword And Return Status    Should Contain    ${output}    stopped 
     #Log List    ${split_list} 
     ${length1}=  Get Length    ${split_list}
     Run Keyword If  ${length1}==0  log  All Services are running Successfully.
     ...    ELSE    Fail    Services are not started and stopped servive\(s\) ${split_list} 
  
        
   
     

