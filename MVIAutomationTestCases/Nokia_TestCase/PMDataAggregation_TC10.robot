*** Settings ***
Library      SSHLibrary
Resource    ../Resource/pmresources.robot
Library    DateTime    
#Library      SCPLibrary    
Library    String 
Library    Collections  
Suite Setup            Open SSH Connection And Login To Omc User
Suite Teardown         Close All Connections      


*** Test Cases ***
PMDataAggregation_TC10
     Get Repo Cron Node

     @{etl_db_output}=    ETL DB Command    ${etl_pv_mon}
     #${k1custom_date}=    Custome Date Format
     ${ktoday_status}=    ETL DB Processed Output  @{etl_db_output}  
     Log To Console    ${ktoday_status} 
      @{et2_db_output}=    ETL DB Command    ${etl_pv_week}
     #${k1custom_date}=    Custome Date Format
     ${ktoday_status1}=    ETL DB Processed Output  @{et2_db_output}  
      @{et3_db_output}=    ETL DB Command    ${etl_pv_day}
     #${k1custom_date}=    Custome Date Format
     ${ktoday_status2}=    ETL DB Processed Output  @{et3_db_output}  
      @{et4_db_output}=    ETL DB Command    ${etl_pv_hour}
     #${k1custom_date}=    Custome Date Format
     ${ktoday_status3}=    ETL DB Processed Output  @{et4_db_output}  
     Run keyword If    ${ktoday_status} and ${ktoday_status1} and ${ktoday_status2} and ${ktoday_status3}  Log  Pass 
     ...  ELSE  Fail  Failed
    
     
          