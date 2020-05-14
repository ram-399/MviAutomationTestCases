*** Settings ***
Library      SSHLibrary
Resource    ../Resource/fmresources.robot
Variables    ../Resource/parameters.yaml
Library      ExcelLibrary

#Library      SCPLibrary    
Library    String 
Library    Collections
Library    DateTime  
Suite Setup     Open SSH Connection And Login To Omc User With Arguments  ${clab492_info.host_ip}  ${clab492_info.user_name}  ${clab492_info.password}     
Suite Teardown  Run KeyWords
...             Close All Connections    AND
...             Close All Excel Documents

*** Test Cases ***
FMNewAlarm_TC7
     [Documentation]    FMNewAlarm
     [Tags]    TC_7
     #Change Root User
     Similator Path
     @{alarm_newfile_output}   Alarm New File Count
     
     Write  ${alarmnew_javacmd}
     Read    delay=1s
     Write  ssh clab689node12
     @{alarmlog_output}  Alarm Log Command  ${alarmnew_logcmd}
     ${count}  Alarm Log Command Processed Output Count  @{alarmlog_output}
      
      
                     
      ${log_file_status}  Alarm New File Count and Log file Processed Output status
       
     
     #Excel Data Reading From Excel File  
      @{db_dates}   Read Excel File and Pass Alarm Number to DB Query
      ${db_result_status}  DB Date List And Requested Date Format     
      
      # this is DB and log file validation part
      Run Keyword If   ${db_result_status} and ${log_file_status}     log  both DB and log file validation is successful!
      ...  ELSE  fail   both DB and log file validation failed!
     
    