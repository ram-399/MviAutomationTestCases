*** Settings ***
Library      SSHLibrary
Variables    ../Resource/parameters.yaml
#Resource    ../Resource/pmresources.robot
Suite Setup            Open SSH Connection And Login To Server
Suite Teardown         Close All Connections  
*** Test Cases ***
Verify the SSH Connection
   Open SSH Connection And Login To Server
    #Write  sudo su -
    #Read    delay=1s    
    #Should Contain    ${temp}   root
    ${output}=  Execute Command  /opt/cpf/sbin/netact_status.sh status | grep started
    Sleep    15s    
    Log To Console    ${output}  
*** Keywords ***
Open SSH Connection And Login To Server
   Open Connection     ${Server data.host_name}
   Login               ${Server data.user_name}        ${Server data.password}  
        