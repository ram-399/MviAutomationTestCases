*** Settings ***
Library      SSHLibrary
Resource    ../Resource/pmresources.robot
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections  
*** Test Cases ***
Verify the SSH Connection
    Open Connection And Log In
    Write  sudo su -
    ${temp} =   Read    delay=1s    
    #Should Contain    ${temp}   root
    #${output}=    Execute Command    /opt/cpf/sbin/netact_status.sh status | grep common_mediations
    #Log To Console    ${output}   
    #Should Contain    ${output}    started
    #Sleep    5 
    Write  /opt/cpf/sbin/smanager.pl status | grep isdk
    #${output1} =      Execute Command    /opt/cpf/sbin/smanager.pl status | grep isdk
    ${output1}=   Read  delay=10s
    Should Contain    ${output1}  started     
        
    #Sleep    8    
    #Execute Command  sudo su -
    #${isdk_oupput}=    Execute Command    /opt/cpf/sbin/smanager.pl status | grep isdk
    #Log To Console        ${isdk_oupput}
        
        
    #Should Contain    ${isdk_oupput}    started 
    #${cmd}    Set Variable    /opt/cpf/sbin/smanager.pl status | grep "db_crons\|rep_crons"
         
    #${db_cmd}=   Execute Command    ${cmd} 
    
    #${db_cmd}=   Wait Until Keyword Succeeds    1m    10s  Execute Command    ${cmd} 
    #Sleep    5
    #Log To Console    ${db_cmd} 
       
    #${cmd}    Set Variable  'db_crons\|rep_crons'         
            
    Write   "/opt/cpf/sbin/smanager.pl status | grep 'db_crons\|rep_crons'"
    ${db_cmd} =     Read  delay=20s
    Should Contain   ${db_cmd}  started     
    Log To Console   ${db_cmd}  
    #Write   /opt/cpf/sbin/smanager.pl status | grep rep_crons
    #${rep_cmd} =     Read  delay=10s
    #Should Contain   ${rep_cmd}  started     
    #Log To Console   ${rep_cmd} 
    
    #Should Contain    ${result}        started
    #Sleep    5    
    #${isdk_oupput}=    Execute Command    /opt/cpf/sbin/smanager.pl status | grep isdk
        
    #Should Contain    ${isdk_oupput}    started 
     
    
            
    