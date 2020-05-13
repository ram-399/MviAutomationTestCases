*** Settings ***
Library      SSHLibrary
Resource    ../Resource/pmresources.robot
Variables    ../Resource/parameters.yaml
Library    DateTime    
#Library      SCPLibrary    
Library    String 
Library    Collections  
Suite Setup           Open SSH Connection And Login To Omc User With Arguments  ${clab689_omcinfo.host_ip}  ${clab689_omcinfo.user_name}  ${clab689_omcinfo.password}
Suite Teardown         Close All Connections      


*** Test Cases ***
PMDataAggregation_TC8
     Get Repo Cron Node
     Write  cd ${directory_path}
     Write  ${error_command}
     ${output}=    Read  delay=2s
     #${split_output}=    Split To Lines  ${output}
     ${output1}=    Remove String Using Regexp     ${output}  [\[a-z@0-9~\\s\$|#\]]*   
     ${count}=    Get Length    ${output1}
     Run Keyword If   ${count}<=0   Log   No Error Files are present
     ...  ELSE   Log  Error Files ${output1} are present