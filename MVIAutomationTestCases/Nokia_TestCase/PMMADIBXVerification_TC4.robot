*** Settings ***
Library      SSHLibrary
Resource    ../Resource/pmresources.robot
Variables    ../Resource/parameters.yaml
Library    String 
Library    Collections   
Suite Setup             Open SSH Connection And Login To Server  ${clab689_info.host_ip}  ${clab689_info.user_name}  ${clab689_info.password}
Suite Teardown         Close All Connections   


*** Test Cases ***
NASDA_Service_TC4
     Change Root User
     Get Common Mediation Node 
     Write   ${mapping_config} 
     ${mapconfig_output}=    Read    delay=15s
     
     ${result1}=    Run Keyword And Return Status    Should Contain   ${mapconfig_output}     com.nokia.ipam:20
     Write    ${converter}          	
     ${converter_output}=    Read    delay=10s
      ${result2}=    Run Keyword And Return Status    Should Contain   ${converter_output}     com.nokia.ipam:20:PM
     Write   ${collecter_config}
     ${collecterconfig_output}=    Read    delay=10s
     ${result3}=    Run Keyword And Return Status    Should Contain   ${collecterconfig_output}     com.nokia.ipam:20
     Run Keyword If    ${result1} and ${result2} and ${result3}    Log  Collector com.nokia.ipam:20 is avaialable       
    ...    ELSE  fail    Collector com.nokia.ipam:20 is not avaialable
                    