#!/bin/bash

cat tmp.txt | sed '1d' | awk -F' ' '{print $1 "\t" $3}'


#Should Contain    ${temp}   root
    Write    /opt/cpf/sbin/smanager.pl status | grep common_mediations
     ${cms_output} =    Read  delay=5s
    #Log To Console    ${output}   
    ${v1}=    Run Keyword And Return Status    Should Contain    ${cms_output}    started
    Run Keyword If    ${v1}    Log To Console    Common mediations node started
    ...    ELSE    Fail    common mediation node not started
    #Sleep    5
    #Write  sudo su -
    #Read    delay=1s  
    Write  /opt/cpf/sbin/netact_status.sh status | grep isdk
    #{isdk_output} =      Execute Command    /opt/cpf/sbin/smanager.pl status | grep isdk
    #Sleep    15   
    ${isdk_output}=    Read  delay=10s
    Log To Console    ${isdk_output}    
    #Should Contain    ${isdk_output}  started  
    ${v2}=    Run Keyword And Return Status    Should Contain    ${isdk_output}    started
    Run Keyword If    ${v2}    Log To Console    ISDK started
    ...    ELSE    Fail    ISDK not started   
        
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
            
    #Write   "/opt/cpf/sbin/smanager.pl status | grep 'db_crons\|rep_crons'"
    #${db_cmd} =     Read  delay=20s
    #Should Contain   ${db_cmd}  started     
    #Log To Console   ${db_cmd}  
    Write   /opt/cpf/sbin/netact_status.sh status | grep rep_crons
    ${rep_cmd} =     Read  delay=10s
    #Should Contain   ${rep_cmd}  started 
    ${v3}=    Run Keyword And Return Status    Should Contain    ${rep_cmd}    started
    Run Keyword If    ${v3}    Log To Console    rep node started
    ...    ELSE    Fail    rep node not started
    Write   /opt/cpf/sbin/netact_status.sh status | grep db_crons
    ${db_cmd} =     Read  delay=10s
    #Should Contain   ${db_cmd}  started 
    ${v4}=    Run Keyword And Return Status    Should Contain    ${db_cmd}    started
    Run Keyword If    ${v4}    Log To Console    db_crons node started
    ...    ELSE    Fail    db_crons node not started     
    