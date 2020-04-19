*** Settings ***
Library      SSHLibrary
Resource    ../Resource/fmresources.robot
Library    String 
Library    Collections  
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections      


*** Test Cases ***
FMAdapterMapping_TC3
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
     Write   /opt/oss/nokianetworks-isdk-platform/bin/isdk_deployment_suite.sh --type SNMPFM-MAPPINGONLY --list | grep -i PCF   
     ${pdf_output}=    Read    delay=15s 
     Log To Console        ${pdf_output} 
     ${result}=    Run Keyword And Return Status    Should Contain    ${pdf_output}    pcf         
     Run Keyword If    ${result}    Log     FM Mapping file is successfully deployed       
     ...    ELSE  fail    FM Mapping file is not deployed and it needs to be deployed! 
                    
          
    
    #: FOR    ${i}     IN     @{result}
    #\    Log To Console    ${i}             
    
