*** Settings ***
Library      SSHLibrary
Library    SeleniumLibrary 
Variables    parameters.yaml 
Library    DateTime 
Library    Collections    
Library    String  
Library      ExcelLibrary       

*** Variables ***
${url}    https://clab689lbwas.netact.nsn-rdnet.net/authentication/Login
${browser}    chrome
${HOST}                10.32.237.58
${USERNAME}            naresh
${PASSWORD}            Nokia_12345
${Package_Value}       com.nsn.netact.nasda.connectivity:IXR7250
${Nct_usrxpath}    //input[@id='login:username']
${Nct_pwdxpath}    //input[@id='login:password']
${login_ele}    //input[@id='login:loginButton']
#TC1 commands and input values

#TC2 commands and input values
${cmdcor}    grep 'com.nsn.netact.nasda.connectivity:PCF' /etc/opt/nokia/oss/nasda/conf/metadata/cmdcon/access/cmdconrelatmx.xml
${cmdint}    grep 'com.nsn.netact.nasda.connectivity:PCF' /etc/opt/nokia/oss/nasda/conf/metadata/cmdint/access/cmdintrelatmx.xml 
#${tc2_input}  FTP  SNMP  SSH  HTTP 
#TC3 commands and input values
${cmd_cmnmed}  /opt/cpf/sbin/netact_status.sh status | grep common_mediations
${pcf_cmd}  /opt/oss/nokianetworks-isdk-platform/bin/isdk_deployment_suite.sh --type SNMPFM-MAPPINGONLY --list | grep -i PCF
${path}   C:\\Users\\marthand\\git\\MviAutomationTestCases\\MVIAutomationTestCases\\TestData\\PCF_AlarmMapping_list.xlsx

#--------------TC7-----------
${alarmnew_logcmd}  grep -inr 'pcf' | grep -inr 'Matching alarms size 1' /var/opt/oss/log/nokianetworks-isdk-snmpfm/isdk_snmpfm_debug.log*
${alarmnew_javacmd}    java -Djava.endorsed.dirs=. com.nsn.snmp.trap.TrapSimulator ${simulatorip.simulator_ip} 10.32.237.56 162 /home/omc/mdk-snmp-simulator/PCF_New.xml
*** Keywords ***
Open SSH Connection And Login To Server
   Open Connection     ${HOST}
   Login               ${USERNAME}        ${PASSWORD}
Open SSH Connection And Login To Omc User
   
   Open Connection     ${clab689_info.host_ip}
   Login               ${clab689_info.user_name}        ${clab689_info.password}
Open SSH Connection And Login To Omc User With Arguments 
   [Arguments]    ${hostname}    ${username}    ${password} 
   Open Connection     ${hostname}
   Login               ${username}        ${password} 
Open Browser To Login Netact Page
    Open Browser    ${url}    ${browser}  options= add_argument("--ignore-certificate-errors")
    Maximize Browser Window
    #Click Element    xpath://*[@id="details-button"]
    #Click Link    xpath://*[@id="proceed-link"]     
    Sleep    3        
    Input Text    ${Nct_usrxpath}        naresh
    Input Password    ${Nct_pwdxpath}        Nokia_12345
    Click Element     ${login_ele}
  
 Custom Date Format
     ${utc_date} =  Get Current Date  UTC
     ${server_date}=    Add Time To Date    ${utc_date}    03:00:00   
     ${custom_date}=    Convert Date  ${server_date}  result_format=%Y-%m-%d-T%H
     [Return]  ${custom_date}
    
 Db Date Format
    ${utc_date} =  Get Current Date  UTC
     ${server_date}=    Add Time To Date    ${utc_date}    03:00:00
    ${db_date_format}=   Convert Date  ${server_date}  result_format=%d.%m.%Y
    [Return]  ${db_date_format}
 Date in Minutes
     ${utc_date} =  Get Current Date  UTC
     ${server_date}=    Add Time To Date    ${utc_date}    03:00:00 
     ${minutes_from_date}=    Convert Date  ${server_date}  result_format=%M
     ${minutes_in_int}=    Convert To Integer   ${minutes_from_date}
     [Return]  ${minutes_in_int}
 Change Root User
    write    sudo su
    Read    delay=2s
 Similator Path 
    Write  ssh ${simulatorip.simulator_ip}
     Read    delay=1s
     Write  cd /home/omc/mdk-snmp-simulator
Alarm New File Count
     Write  cat PCF_New.xml
     ${inputfile}=  Read  delay=2s
     @{alarmnewcount_list}=    Split To Lines  ${input_file}  1 
     [Return]  @{alarmnewcount_list}
       
Alarm New File Count and Log file Processed Output status
       [Arguments]  @{kalarm_newfile_output}       
       @{trapid}=    Create List
       ${kcount}     Alarm Log Command Processed Output Count
       :FOR  ${k}  IN  @{kalarm_newfile_output} 
      \    ${count1}=    Get Regexp Matches     ${k}   trapOid="[0-9].*
      \    ${count2}=    Get Length  ${count1}
      \    Run Keyword If  ${count2} > 0  Append To List    ${trapid}  ${count1}    
      #Log To Console  ${trapid}
      ${list_count}=    Get Length    ${trapid}
      #Log To Console  ${list_count}
      #Log To Console  ${count}
     
     ${log_file_status}=    Run keyword If  ${list_count}==${kcount}  Set Variable  True
      ...  ELSE  Set Variable    False
      [Return]   ${log_file_status} 
 Alarm Log Command
      [Arguments]  ${kalarmnew_logcmd}
      Write  ${kalarmnew_logcmd}
      ${output_common}=    Read  delay=10s
      @{alarm_list}=    Split To Lines  ${output_common}  9
     [Return]  @{alarm_list}  
 Alarm Log Command Processed Output Count
     [Arguments]   @{kalarmlog_output} 
     ${kcustom_date}=    Custom Date Format
     ${kminutes_in_int}   Date in Minutes
     
     @{result_list}=    Create List 
     # # #${pattern}=  Set Variable    K?(\d{4})-((0[1-9])|(1[0-2]))-(0[1-9]|[12][0-9]|3[01])-T([01][0-9]|2[0-3]):([0-5]?[0-9])      
       :FOR  ${i}  IN  @{kalarmlog_output}
       \    ${result}=     Get Regexp Matches    ${i}  ${kcustom_date}:([0-5]?[0-9])
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
       \    ${count}=  Run Keyword If  ${rmv_min_in_int}>=${kminutes_in_int}  Evaluate  ${count} + 1    
       \    ...  ELSE  Set Variable    ${count}
       [Return]  ${count}
 Read Excel File and Pass Alarm Number to DB Query
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
     [Return]   @{db_dates}
 
 DB Date List And Requested Date Format
    [Arguments]   @{kdb_dates}
     @{db_date_list}  Create List
     ${kdb-date_format}      Db Date Format
     :FOR  ${i}  IN  @{kdb_dates}
      \    ${result}=     Get Regexp Matches    ${i}  (0[0-9]|[1-2][0-9]|[0-3]).(0[0-9]|1[0-2]).([0-9]{4})
      \    ${count_length}  Get Length    ${result}
      \    Run Keyword If  ${count_length}>0  Append To List    ${db_date_list}  ${result} 
      
     :FOR  ${j}  IN  @{db_date_list}
       \    ${req_date_output}  Set Variable    ${j[0]}        
       \    ${status_bulean}=  Run Keyword And Return Status   Should Be Equal   ${kdb-date_format}      ${req_date_output}         
       \    ${db_result_status}=  Run Keyword If   ${status_bulean}     Set Variable    ${status_bulean} 
      [Return]  ${db_result_status}   
     
         