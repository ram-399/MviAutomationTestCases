*** Settings ***
Library      SSHLibrary
Library    SeleniumLibrary 
Variables    parameters.yaml 
Library    DateTime      

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

*** Keywords ***
Open SSH Connection And Login To Server
   Open Connection     ${HOST}
   Login               ${USERNAME}        ${PASSWORD}
Open SSH Connection And Login To Omc User
   
   Open Connection     ${clab689_info.host_ip}
   Login               ${clab689_info.user_name}        ${clab689_info.password}

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
     ${db_date_format}=   Convert Date  ${server_date}  result_format=%d.%m.%Y
     ${minutes_from_date}=    Convert Date  ${server_date}  result_format=%M
     ${minutes_in_int}=    Convert To Integer   ${minutes_from_date}             