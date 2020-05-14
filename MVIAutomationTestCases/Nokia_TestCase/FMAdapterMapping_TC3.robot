*** Settings ***
Library      SSHLibrary
Resource    ../Resource/fmresources.robot
Library    String 
Library    Collections  
Suite Setup            Open SSH Connection And Login To Server
Suite Teardown         Close All Connections      


*** Test Cases ***
FMAdapterMapping_TC3
     [Documentation]    FMAdapterMappingInstallation
     [Tags]    TC_3
     Open SSH Connection And Login To Server
     write    sudo su
     Read    delay=2s
     Write   ${cmd_cmnmed}
     ${output}=  Read    delay=5s
     @{str1}=    Split String    ${output}    -
     @{result}=    Split String    @{str1}[1]    ${SPACE}
    #Log To Console        @{result}[0]
     ${ssh_commed}=  Get From List  ${result}  0
     Write  ssh ${ssh_commed}
     Read    delay=1s
     Write   ${pcf_cmd}   
     ${pdf_output}=   Read    delay=17s 
     ${result}=    Run Keyword And Return Status    Should Contain    ${pdf_output}    pcf         
     Run Keyword If    ${result}    Log  Mapping file is deployed in successful state.      
     ...    ELSE  fail    Mapping file is not deployed 
          
    
    #: FOR    ${i}     IN     @{result}
    #\    Log To Console    ${i}             
    
