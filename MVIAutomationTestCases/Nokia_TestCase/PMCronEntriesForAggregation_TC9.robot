*** Settings ***
Library      SSHLibrary
Resource    ../Resource/pmresources.robot
Variables    ../Resource/parameters.yaml
#Library      SCPLibrary    
Library    String 
Library    Collections  
Suite Setup            Open SSH Connection And Login To Server  ${clab689_omcinfo.host_ip}  ${clab689_omcinfo.user_name}  ${clab689_omcinfo.password}
Suite Teardown         Close All Connections      


*** Test Cases ***
PMCronEntriesForAggregation_TC9
    #write    sudo su
    #Read    delay=2s
     Get Repo Cron Node
     Write    ${crontab_cmd}
     ${crontab_output}=    Read    delay=5s 
     Log To Console        ${crontab_output}
     ${crontab_status}=    Run Keyword And Return Status    Should Contain    ${crontab_output}    MADIPA
     Write  sqlplus omc/omc
     #Read  delay=5s
     Write  select distinct AGG_ON from raa_t_conf where data_module = 'madipa';
     ${db_output}=    Read  delay=5s 
     @{db_agg}=    Split To Lines      ${db_output}  13  16 
     Remove From List     ${db_agg}  1
     #Log To Console        ${db_output}
     Log List    ${db_agg}
     @{db_res}=    Create List 
     :FOR  ${i}  IN   @{db_agg}
     \    ${strip_str}=    Strip String   ${i}  
     \    Append To List   ${db_res}  ${strip_str}
     
     Log List    ${db_res}
    ${agg_status}=    Run Keyword And Return Status    List Should Contain Value  ${db_res}  1    
     Run Keyword If  ${crontab_status} and ${agg_status}  Log  Pass
     ...  ELSE  Fail  Failed 
        
    
        