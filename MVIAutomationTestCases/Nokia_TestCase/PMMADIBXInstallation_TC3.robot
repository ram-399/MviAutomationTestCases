*** Settings ***
Library      SSHLibrary
Resource    ../Resource/fmresources.robot
Library    String 
Library    Collections  
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections      


*** Test Cases ***
PMMADIPATestCase_TC3
     Open Connection And Log In
     write    sudo su
     Read    delay=2s
     Write   /opt/cpf/sbin/netact_status.sh status service rep_crons
     ${output}=  Read    delay=5s
     @{str1}=    Split String    ${output}    :
     @{result}=    Split String    @{str1}[1]    ${SPACE}
    #Log To Console        @{result}[0]
     ${ssh_commed}=  Get From List  ${result}  0
     Log To Console    ${ssh_commed} 
     Write  ssh ${ssh_commed}
     Read    delay=3s
     Write    /usr/bin/nokia/ManageSS.pl --list UMAMAD MADIPA 
     ${pdf_output}=    Read    delay=15s 
     Log To Console        ${pdf_output}
     Write    /usr/bin/nokia/ManageSS.pl --list UMAMAD MADIPA-DB
     ${pdf_output1}=    Read    delay=15s 
     Log To Console        ${pdf_output1}
     ${result}=    Run Keyword And Return Status    Should Contain    ${pdf_output}    (CONFIGURED) (ACTIVATED) (ACTIVE)        
     Run Keyword If    ${result}    Log     MADIPA is Configured and Activated in NetAct!       
     ...    ELSE  fail    MADIPA is not Configured and Activated in NetAct and it needs to be deployed
     ${result1}=    Run Keyword And Return Status    Should Contain    ${pdf_output}    (CONFIGURED) (ACTIVATED) (ACTIVE)          
     Run Keyword If    ${result1}    Log    MADIPA-DB is Configured and Activated in NetAct!       
     ...    ELSE  fail    MADIPA-DB is not Configured and Activated in NetAct and it needs to be deployed    
  
     

