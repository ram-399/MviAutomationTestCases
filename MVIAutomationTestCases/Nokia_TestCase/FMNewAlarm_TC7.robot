*** Settings ***
Library      SSHLibrary
Resource    ../Resource/fmresources.robot
Variables    ../Resource/parameters.yaml
Library      ExcelLibrary

#Library      SCPLibrary    
Library    String 
Library    Collections
Library    DateTime  
Suite Setup     Open SSH Connection And Login To Server      
Suite Teardown  Run KeyWords
...             Close All Connections    AND
...             Close All Excel Documents

*** Test Cases ***
FMNewAlarm_TC7
     
     write    sudo su
     Read    delay=2s
     Write  ssh ${simulatorip.simulator_ip}
      Read    delay=1s
      Write  cd /home/omc/mdk-snmp-simulator
      Write  cat PCF_New.xml
     ${inputfile}=  Read  delay=2s
     
      Write  java -Djava.endorsed.dirs=. com.nsn.snmp.trap.TrapSimulator ${simulatorip.simulator_ip} 10.32.237.56 162 /home/omc/mdk-snmp-simulator/PCF_New.xml
      Read    delay=1s
      Write  ssh clab689node12
      Write  grep -inr 'pcf' | grep -inr 'Matching alarms size 1' /var/opt/oss/log/nokianetworks-isdk-snmpfm/isdk_snmpfm_debug.log*
      ${output_common}=    Read  delay=10s
    
   
         
     
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
     
     ${log_output}=    Run keyword If  ${list_count}==${count}  Set Variable  True
      ...  ELSE  Set Variable    False
     #Excel Data Reading From Excel File  
     Open Excel Document    ${path}    1
     #${data}    Read Excel Row   row_num=2
     @{col_data}  Read Excel Column    col_num=3 
     Remove Values From List    ${col_data}    AlarmId 
     ${alarm_num}  Get From List    ${col_data}    1
     Write  sqlplus omc/omc
     #Read  delay=5s
     Write  select EVENT_TIME from fx_alarm where ALARM_NUMBER=${alarm_num};
     ${db_output}=    Read  delay=5s 
     @{db_dates}=    Split To Lines      ${db_output}  1  -2
     @{db_date_list}  Create List    
     :FOR  ${i}  IN  @{db_dates}
      \    ${result}=     Get Regexp Matches    ${i}  (0[0-9]|[1-2][0-9]|[0-3]).(0[0-9]|1[0-2]).([0-9]{4})
      \    ${count_length}  Get Length    ${result}
      \    Run Keyword If  ${count_length}>0  Append To List    ${db_date_list}  ${result} 
      
     :FOR  ${j}  IN  @{db_date_list}
       \    ${req_date_output}  Set Variable    ${j[0]}        
       \    ${status_bulean}=  Run Keyword And Return Status   Should Be Equal   ${db_date_format}      ${req_date_output}         
       \    ${db_result}=  Run Keyword If   ${status_bulean}     Set Variable    ${status_bulean}           
      
      # this is DB and log file validation part
      Run Keyword If   ${db_result} and ${log_output}      log  both DB and log file validation is successful!
      ...  ELSE  fail   both DB and log file validation failed!
     
    