*** Settings ***
Library      SSHLibrary
Library    SeleniumLibrary 
Library    String    
Library    Collections  
Library    DateTime      
Variables    parameters.yaml

*** Variables ***
${url}    https://clab689lbwas.netact.nsn-rdnet.net/authentication/Login
${browser}    chrome
${HOST}                10.32.237.58
${USERNAME}            naresh
${PASSWORD}            Nokia_12345
${omc_user}             omc
${omc_pwd}              Arthur_987
${Package_Value}       com.nsn.netact.nasda.connectivity:IXR7250
${Nct_usrxpath}    //input[@id='login:username']
${Nct_pwdxpath}    //input[@id='login:password']
${login_btn}    //input[@id='login:loginButton']
${Global_Directory}    ${CURDIR}
#--------TC1-----------
${netactpm_cmd}    /opt/cpf/sbin/smanager.pl status | grep -e 'db_crons' -e 'rep_crons' -e 'isdk-ftp-pm' -e 'isdk-snmp-pm' -e 'common_mediation'
#---------TC2 commands and input values------------
${cmdcon}    grep 'com.nsn.netact.nasda.connectivity:IPAM' /etc/opt/nokia/oss/nasda/conf/metadata/cmdcon/access/cmdconrelatmx.xml
${cmdintr}    grep 'com.nsn.netact.nasda.connectivity:IPAM' /etc/opt/nokia/oss/nasda/conf/metadata/cmdint/access/cmdintrelatmx.xml
#---------TC3 commands and input values------------
${rep_crons}    /opt/cpf/sbin/netact_status.sh status service rep_crons
${madipa}    /usr/bin/nokia/ManageSS.pl --list UMAMAD MADIPA
${madipa_db}    /usr/bin/nokia/ManageSS.pl --list UMAMAD MADIPA-DB
#---------TC4 commands and input values--------------
${nct_cmnmed}    /opt/cpf/sbin/netact_status.sh status | grep common_mediations
${mapping_config}    sh /opt/oss/nokianetworks-isdk-platform/isdk_deployment_suite.sh --type MAPPINGCONFIG --list |grep com.nokia.ipam:20
${converter}    sh /opt/oss/nokianetworks-isdk-platform/isdk_deployment_suite.sh --type CONVERTER --list | grep com.nokia.ipam:20:PM
${collecter_config}    sh /opt/oss/nokianetworks-isdk-platform/isdk_deployment_suite.sh --type COLLECTORCONFIG --list | grep com.nokia.ipam:20
#----------------TC6-----------
${common_med}    /opt/cpf/sbin/netact_status.sh status | grep common_mediations
${rawfile_dir}    cd /var/opt/nokia/oss/global/isdk/packages/mdk/collectedFiles/Collector001/PLMN-PLMN/NCAAA-1/TIPAM-1/home
#----------------TC7-----------
${etl_pv}        etlcolDBInfo.pl -t %MADIPA_PV_%RAW
${etl_ps}        etlcolDBInfo.pl -t %MADIPA_PS_%RAW


#----------------TC9-----------
${crontab_cmd}   crontab -l | grep -i MADIPA
#----------------TC10-----------
${etl_pv_mon}     etlcolDBInfo.pl -t MADIPA%PV%MON
${etl_pv_week}    etlcolDBInfo.pl -t MADIPA%PV%WEEK
${etl_pv_day}     etlcolDBInfo.pl -t MADIPA%PV%DAY
${etl_pv_hour}    etlcolDBInfo.pl -t MADIPA%PV%HOUR
#----------------TC11-----------
${directory_path}    /var/opt/nokia/oss/rep/etload/
${error_command}    ll */*/* | grep -inr ""omes"" | grep ""MADIPA""

*** Keywords ***
Open SSH Connection And Login To Server
   [Arguments]   ${hostname}  ${useranme}  ${password}
   Open Connection     ${hostname} 
   Login               ${useranme}        ${password}
Open SSH Connection And Login To Omc User
    
   Open Connection     ${clab492_info.host_ip}
   Login               ${clab492_info.user_name}        ${clab492_info.password}
Open SSH Connection And Login To Omc User With Arguments 
   [Arguments]    ${hostname}    ${username}    ${password} 
   Open Connection     ${hostname}
   Login               ${username}        ${password} 

# Open SSH Connection And Login To Omc User
   # open ssh connection to host with password  ${HOST}  ${omc_user}  ${omc_pwd}


Open Browser To Login Netact Page
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs}    Create Dictionary    download.default_directory=${Global_Directory}    plugins.plugins_disabled=disabled
    Call Method    ${chrome options}    add_experimental_option    prefs    ${prefs}

    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Call Method    ${chrome_options}    add_argument    --ignore-certificate-errors
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    go to   ${url}
    #Open Browser    ${url}    ${browser}  options= add_argument("--ignore-certificate-errors")
    Maximize Browser Window
    #Click Element    xpath://*[@id="details-button"]
    #Click Link    xpath://*[@id="proceed-link"]     
    Sleep    3        
    Input Text    ${Nct_usrxpath}        naresh
    Input Password    ${Nct_pwdxpath}        Nokia_12345
    Click Element     ${login_btn}   

Change Root User
    write    sudo su
    Read    delay=2s    
Get Repo Cron Node
    Write   ${rep_crons}
     ${output}=  Read    delay=10s
     @{str1}=    Split String    ${output}    :
     @{result}=    Split String    @{str1}[1]    ${SPACE}
    #Log To Console        @{result}[0]
     ${ssh_commed}=  Get From List  ${result}  0
     Log To Console    ${ssh_commed} 
     Write  ssh ${ssh_commed}
     Read    delay=3s 
Get Common Mediation Node     
     Write   ${common_med} 
     ${output}=  Read    delay=5s
     @{str1}=    Split String    ${output}    -
     @{result}=  Split String    @{str1}[1]    ${SPACE}
    #Log To Console        @{result}[0]
     ${ssh_commed}=  Get From List  ${result}  0
     Log To Console    ${ssh_commed} 
     Write  ssh ${ssh_commed}
     Read    delay=2s
     
Custom Date Format
    ${utc_date} =  Get Current Date  UTC
    ${server_date}=    Add Time To Date    ${utc_date}    03:00:00   
    ${custom_date}=    Convert Date  ${server_date}  result_format=%Y/%m/%d 
    [Return]    ${custom_date}
ETL DB Command
    [Arguments]   ${ketl_pv_mon}
     Write    ${ketl_pv_mon} 
     ${pv_output}=    Read    delay=30s
     Log To Console    ${pv_output}     
     @{pv_list}=  Split To Lines    ${pv_output}    15  -8 
     #Return  [${pv_list}]
     [Return]  @{pv_list}  
ETL DB Processed Output 
    [Arguments]    @{ketl_db_output}  
    ${kcustom_date}=    Custom Date Format  
     @{pv_final_list}=    Create List 
    :FOR  ${i}  IN  @{ketl_db_output}
   # \    ${remove_tab}=   Remove String  ${i}  \t   
    \     ${remove_morepsaces}=  Replace String Using Regexp    ${i}   \\s{2,}     ${SPACE}    
    \    ${remove_space}=  Split String  ${remove_morepsaces}  ${SPACE}
    \    Append To List  ${pv_final_list}  ${remove_space}[2]
    @{pvtoday_values}  Create List 
    @{pvdate_values}  Create List       
    :FOR  ${j}  IN  @{pv_final_list}
    \    ${sep_values}=  Split String  ${j}  \t
    \    Append To List  ${pvtoday_values}  ${sep_values}[0]
    \    Append To List  ${pvdate_values}  ${sep_values}[1]
    ${pvtoday_status}=    Run Keyword And Return Status    List Should Not Contain Value  ${pvtoday_values}  0 
    ${pvdate_status}=    Run Keyword And Return Status    List Should Contain Value  ${pvdate_values}  ${kcustom_date}
    ${ketl_stauts}=  Run Keyword If  ${pvtoday_status} and ${pvdate_status}  Set Variable    True 
    ...              ELSE  Set Variable    False  
    [Return]   ${ketl_stauts}     
                        