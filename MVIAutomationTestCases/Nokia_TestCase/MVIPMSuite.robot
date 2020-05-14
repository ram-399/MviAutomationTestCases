*** Settings ***
Library      SSHLibrary
Library    SeleniumLibrary
Resource    ../Resource/pmresources.robot
Resource    ../Resource/pmlocators.robot
Library    String 
Library    Collections  
Suite Setup    Run KeyWords
#...            Open SSH Connection And Login To Server

Suite Teardown  Run KeyWords
...             Close All Connections    AND
...             Close All Browsers 
*** Test Cases ***
PMNetactService_TC1
    [Documentation]    NetAct Service Verification
    [Tags]    TC_1
    Write  sudo su -   
    Read    delay=1s    
    Write   ${netactpm_cmd}   
    ${output}=  Read    delay=15s 
    
    @{split_list}=    Create List     
     #Log To Console         ${output}
    @{str1}=  Split To Lines  ${output}  0  -1 
    
    @{split_list}=    Create List     
    # #${count}=    Get Length    ${str1}
    # #Log To Console  ${count}
    :FOR  ${j}  IN  @{str1}
   #\    ${res}=  Strip String  ${j}
    \    ${split_str}=    Remove String Using Regexp  ${j}  ([^a-z0-9_]|31m|01)
        
    \   Append To List  ${split_list}  ${split_str}    
     @{result_list}=  Create List    
     :FOR    ${cmdintre_value}  IN    @{split_list}
     
    \    ${v2}=    Run Keyword And Return Status    Should Contain  ${cmdintre_value}  started
    \     Run Keyword If   ${v2}  Log  NASDA Object ${cmdintre_value} avaialable 
     \     ...    ELSE  Append To List  ${result_list}  ${cmdintre_value}
     ${result_count}=  Get Length    ${result_list}
     Run Keyword If  ${result_count}==0    Pass Execution  NASDA Objects are available
     ...    ELSE  Fail  NASDA Objects ${result_list} are not available
     
PMNASDAVerification_TC2
    ${IPAM_output1}=  Execute Command    ${cmdcon}
    Sleep  5
    ${IPAM_output2}=    Execute Command    ${cmdintr}        
      @{list_1}=  Create List
     @{output}=  Split To Lines  ${IPAM_output2}
     :FOR  ${i}  IN  @{output}
     \  ${stp_string}=    Strip String  ${i}    
     \   Append To List  ${list_1}   ${stp_string}
     @{fin_list}=    Create List
     :FOR  ${k}  IN  @{list_1}
     \    ${match}=    Should Match Regexp  ${k}  "CHILD_[A-Z]*"
     \    ${reqop}=  Remove String Using Regexp   ${match}  CHILD_
     \    ${rmv_qua}=  Remove String    ${reqop}    "
     \    Append To List  ${fin_list}  ${rmv_qua}
     
     @{result_list}=    Create List
     ${result1}=    Run Keyword And Return Status    Should Contain    ${IPAM_output1}    CHILD_IPAM
     Run Keyword If   ${result1}   Log  NASDA Object IPAM avaialable.        
     ...    ELSE  Append To List  CHILD_IPAM 
     
     @{list1}=    Create List    FTP  SNMP  SSH  
     :FOR    ${cmdintre_value}  IN    @{list1}
     \    ${result2}=   Run Keyword And Return Status    Should Contain  ${fin_list}       ${cmdintre_value}
     \     Run Keyword If   ${result2}  Log  NASDA Object ${cmdintre_value} avaialable 
     \     ...    ELSE  Append To List  ${result_list}  ${cmdintre_value}
     ${result_count}=  Get Length    ${result_list}
    
     Run Keyword If  ${result_count}==0    Pass Execution  NASDA Objects are available
     ...    ELSE  Fail  NASDA Objects ${result_list} are not available

PMMADIPATestCase_TC3
    [Documentation]    Adaptation Installation:MADIBX
    [Tags]    TC_3
     Change Root User
     Get Repo Cron Node
     Write    ${madipa} 
     ${pdf_output}=    Read    delay=15s 
     #Log To Console        ${pdf_output}
     Write    ${madipa_db}
     ${pdf_output1}=    Read    delay=15s 
     #Log To Console        ${pdf_output1}
     ${result1}=    Run Keyword And Return Status    Should Contain    ${pdf_output}    (CONFIGURED) (ACTIVATED) (ACTIVE)        
     #Run Keyword If    ${result}  Log  MADIPA is Installed!           
     #...    ELSE  Log    MADIPA is not Installed!
     ${result2}=    Run Keyword And Return Status    Should Contain    ${pdf_output1}    (CONFIGURED) (ACTIVATED) (ACTIVE)          
     #Run Keyword If    ${result1}    Pass Execution If  ${result1}  MADIPA is installed          
     #...    ELSE  Log    MADIPA-DB is not installed 
     Run Keyword If    ${result1} and ${result2}    Log  MADIPA and MADIPA-DB are installed successfully
     ...    ELSE IF    '${result1}' == 'True' and '${result2}' == 'False'   log  MADIPA is not installed
     ...    ELSE IF    '${result1}' == 'False' and '${result2}' == 'True'  log  MADIPA-DB is not installed 
     ...    ELSE    Log  MADIPA and MADIPA-DB are not installed
      Run Keyword If    ${result1} and ${result2}  log  pass 
      ...   ELSE  Fail  fail 
  
     
NASDA_Service_TC4
    [Documentation]    Mediation Installation :MADIBX
    [Tags]    TC_4
    
     write    sudo su
     Read    delay=2s
     Write   ${nct_cmnmed}
     ${output}=  Read    delay=5s
     @{str1}=    Split String    ${output}    -
     @{result}=  Split String    @{str1}[1]    ${SPACE}
    #Log To Console        @{result}[0]
     ${ssh_commed}=  Get From List  ${result}  0
     #Log To Console    ${ssh_commed} 
     Write  ssh ${ssh_commed}
     Read    delay=2s
     Write   ${mapping_config} 
     ${mapconfig_output}=    Read    delay=15s
     
     ${result1}=    Run Keyword And Return Status    Should Contain   ${mapconfig_output}     com.nokia.ipam:20
     Write    ${converter}          	
     ${converter_output}=    Read    delay=15s
      ${result2}=    Run Keyword And Return Status    Should Contain   ${converter_output}     com.nokia.ipam:20:PM
     Write   ${collecter_config}
     ${collecterconfig_output}=    Read    delay=15s
     ${result3}=    Run Keyword And Return Status    Should Contain   ${collecterconfig_output}     com.nokia.ipam:20
     Run Keyword If    ${result1} and ${result2} and ${result3}    Log  Collector com.nokia.ipam:20 is avaialable       
    ...    ELSE  fail    Collector com.nokia.ipam:20 is not avaialable  
     
LaunchBrowser and Login to app
    [Documentation]    NEAC Verifications   
    [Tags]    TC_5
    Open Browser To Login Netact Page
    #Sleep    3    
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${accept_btn}
    #Sleep    3 
    #click on Security tab
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${security_tab}   
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${security_tab1}    
    #Sleep    5    
    Wait Until Keyword Succeeds	100s	10s  Select Window    Network Element Access Control - CLAB689 - naresh
    
    Capture Page Screenshot     TC5_pcf1.png
    Input Text    ${inputext_ele}  com.nokia.pcf-9.12.5/PCF                             #com.nokia.canloc-1.0/CANLOC
    
    Press Keys    ${enter_key}  ENTER
    Sleep    10    
    Capture Page Screenshot     TC5_pcf2.png
    ${result_text}=    Run Keyword And Return Status   Element Should Be Visible   ${Adaption_textele}    
              
    Run Keyword If    ${result_text}    Log  com.nokia.pcf-9.12.5/PCF is available       
    ...    ELSE  fail    com.nokia.pcf-9.12.5/PCF is not available
 
PMRawDataCollection_TC6
    [Documentation]    PMRawDataCollection   
    [Tags]    TC_6
     write    sudo su
     Read    delay=2s
     Write  cd /home/naresh/tmp
     Write   ls -lrt 
     ${raw_file}=  Read    delay=2s
     ${raw_file1}=    Run Keyword And Return Status  Should Contain  ${raw_file}  A20200417.0755+0200-0800+0205.xml  
     
     #${length}=  Get Length    ${raw_file}  
     Run Keyword if  ${raw_file1}  log  rawfile is exist under the tmp directory
     ...  ELSE  fail  rawfile is not exist under the tmp directory!
     
     Write  scp A20200417.0755+0200-0800+0205.xml root@clab689node12:/var/opt/nokia/oss/global/isdk/packages/mdk/collectedFiles/Collector001/PLMN-PLMN/NCAAA-1/TIPAM-1/home
     ${output}=    Read  delay=5s
     log  ${output}
     Write   ${common_med}
     ${output}=  Read    delay=7s
     @{str1}=    Split String    ${output}    -
     @{result}=    Split String    @{str1}[1]    ${SPACE}
    #Log To Console        @{result}[0]
     ${ssh_commed}=  Get From List  ${result}  0
     Log To Console    ${ssh_commed} 
     Write  ssh ${ssh_commed}
     Read    delay=1s
     Write   ${rawfile_dir} 
     Write   ls -lrt  
     ${pdf_output}=    Read    delay=5s 
     ${result}=    Run Keyword And Return Status    Should Contain    ${pdf_output}    A20200417.0755+0200-0800+0205.xml        
     Run Keyword If    ${result}    Log    Raw Data file is copined into the desired location!        
     ...    ELSE  fail    Raw Data file is copined into the desired location!   