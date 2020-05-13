*** Settings ***
Library      SSHLibrary
Resource    ../Resource/fmresources.robot
Variables    ../Resource/parameters.yaml
#Library      SCPLibrary    
Library    String 
Library    Collections
Library    DateTime  
Suite Setup            Open SSH Connection And Login To Server
Suite Teardown         Close All Connections      


*** Test Cases ***
FMInvalidTrapOID_TC8
     write    sudo su
     Read    delay=2s
     
     Write  ssh ${simulatorip.simulator_ip}
     Read    delay=1s
     Write  cd /home/omc/mdk-snmp-simulator
     Write  cat PCF_Trap_InvalidOid.xml
     ${inputfile}=  Read  delay=2s
     
      Write  java -Djava.endorsed.dirs=. com.nsn.snmp.trap.TrapSimulator ${simulatorip.simulator_ip} 10.32.237.56 162 /home/omc/mdk-snmp-simulator/PCF_Trap_InvalidOid.xml
      Read    delay=1s
      Write  ssh clab689node12
      Write  grep -inr 'pcf' | grep -inr 'Matching alarms size 0' /var/opt/oss/log/nokianetworks-isdk-snmpfm/isdk_snmpfm_debug.log*
      ${output_common}=    Read  delay=10s
     ${utc_date} =  Get Current Date  UTC
   
     ${server_date}=    Add Time To Date    ${utc_date}    03:00:00   
     ${custom_date}=    Convert Date  ${server_date}  result_format=%Y-%m-%d-T%H
     ${db_date_format}=   Convert Date  ${server_date}  result_format=%d.%m.%Y
     ${minutes_from_date}=    Convert Date  ${server_date}  result_format=%M
     ${minutes_in_int}=    Convert To Integer   ${minutes_from_date}    
     
       @{split_lines}=    Split To Lines  ${output_common}  9
       @{result_list}=    Create List 
     # # #${pattern}=  Set Variable    K?(\d{4})-((0[1-9])|(1[0-2]))-(0[1-9]|[12][0-9]|3[01])-T([01][0-9]|2[0-3]):([0-5]?[0-9])      
       :FOR  ${i}  IN  @{split_lines}
       \    ${result}=     Get Regexp Matches    ${i}  ${custom_date}:([0-5]?[0-9])
       \    ${length_str}=    Get Length  ${result}
       \    Run Keyword If  ${length_str}>0  Append To List    ${result_list}  ${result}   
     # # #${result}=    Get Matches  ${split_lines}  K2020-04-30-T09:10
       @{result_list1}=    Create List 
       ${count}    Set Variable    0 
       :FOR  ${i}  IN  @{result_list}
       \    ${string_value}  Set Variable    ${i[0]}
       \    ${minute}=    Should Match Regexp  ${string_value}  :[0-5][0-9]
       \    ${rmv_minutes}=    Remove String  ${minute}  :
       \    ${rmv_min_in_int}=    Convert To Integer  ${rmv_minutes}
      # #\    Run Keyword If    ${minutes_from_date}<=${rmv_minutes}  Append To List  ${result_list1}  ${rmv_minutes}
       \    ${count}=  Run Keyword If  ${rmv_min_in_int}>=${minutes_in_int}  Evaluate  ${count} + 1    
       \    ...  ELSE  Set Variable    ${count}
        @{trapid}=    Create List
      @{split_lines2}=    Split To Lines  ${input_file}  1  
      :FOR  ${k}  IN  @{split_lines2}  
      \    ${count1}=    Get Regexp Matches     ${k}   trapOid="[0-9].*
      \    ${count2}=    Get Length  ${count1}
      \    Run Keyword If  ${count2} > 0  Append To List    ${trapid}  ${count1}    
      #Log To Console  ${trapid}
      ${list_count}=    Get Length    ${trapid}
      #Log To Console  ${list_count}
      #Log To Console  ${count}
     
      Run keyword If  ${list_count}==${count}  log  pass
      ...  ELSE  Fail  Fail
                     