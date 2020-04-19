*** Settings ***
Library      SSHLibrary
Resource    ../Resource/pmresources.robot
Library    String 
Library    Collections   
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections   


*** Test Cases ***
NASDA_Service_TC2
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
     Read    delay=5s
     Write   sh /opt/oss/nokianetworks-isdk-platform/isdk_deployment_suite.sh --type MAPPINGCONFIG --list
     ${output_ssh}=    Read    delay=10s
     Log To Console    ${output_ssh}
     Write    sh /opt/oss/nokianetworks-isdk-platform/isdk_deployment_suite.sh --type CONVERTER --list 
              	
     ${output_ssh1}=    Read    delay=10s
    Log To Console     ${output_ssh1}
    Write   sh /opt/oss/nokianetworks-isdk-platform/isdk_deployment_suite.sh --type COLLECTORCONFIG --list
     ${output_ssh3}=    Read    delay=10s
    Log To Console     ${output_ssh3}
                    