*** Settings ***
Library      SSHLibrary
Resource    ../Resource/fmresources.robot
Library    String 
Library    Collections  
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections      


*** Test Cases ***
PMRawDataCollection_TC6
     Open Connection And Log In
     write    sudo su
     Read    delay=2s
     Write   /opt/cpf/sbin/netact_status.sh status | grep common_mediations
     ${output}=  Read    delay=5s
     @{str1}=    Split String    ${output}    -
     @{result}=    Split String    @{str1}[1]    ${SPACE}
    #Log To Console        @{result}[0]
     ${ssh_commed}=  Get From List  ${result}  0
     Log To Console    ${ssh_commed} 
     Write  ssh ${ssh_commed}
     Read    delay=1s
     Write   cd /var/opt/nokia/oss/global/isdk/packages/mdk/collectedFiles_PUT 
     Write   ls -lrt  
     ${pdf_output}=    Read    delay=5s 
     Log To Console        ${pdf_output} 
     ${result}=    Run Keyword And Return Status    Should Contain    ${pdf_output}    com.nokia.ipam_20         
     Run Keyword If    ${result}    Log     com.nokia.ipam_20 Raw Data collection file is listed        
     ...    ELSE  fail    No Raw Data collection file is installed! 