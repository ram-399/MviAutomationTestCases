*** Settings ***
Library      SSHLibrary
Resource    ../Resource/pmresources.robot
Variables    ../Resource/parameters.yaml
Library    String 
Library    Collections  
Suite Setup            Open SSH Connection And Login To Server  ${clab492_info.host_ip}  ${clab492_info.user_name}  ${clab492_info.password}
Suite Teardown         Close All Connections      


*** Test Cases ***
PMMADIPATestCase_TC3
    [Documentation]    Adaptation Installation:MADIBX
    [Tags]    TC_3
     #Change Root User
     Get Repo Cron Node
     Write    ${madipa} 
     ${pdf_output}=    Read    delay=15s
     ${pdf_result}=    Remove String Using Regexp    ${pdf_output}  ^[A-Z-.0-9\s]*  [\[a-z@0-9~\\s\$|#\]]* 
   
     #Log To Console        ${pdf_output}
     Write    ${madipa_db}
     
     ${pdf_output1}=    Read    delay=15s 
     ${pdf_result1}=    Remove String Using Regexp    ${pdf_output1}  ^[A-Z-.0-9\s]*  [\[a-z@0-9~\\s\$|#\]]*
     #${pdf_result1}    Remove String Using Regexp    ${pdf_remove_startstring1}  [\[a-z@0-9~\\s\$|#\]]*
     #Log To Console        ${pdf_output1}
     ${result1}=    Run Keyword And Return Status    Should Match    ${pdf_result}    (CONFIGURED)(ACTIVATED)        
     #Run Keyword If    ${result}  Log  MADIPA is Installed!           
     #...    ELSE  Log    MADIPA is not Installed!
     ${result2}=    Run Keyword And Return Status    Should Match    ${pdf_result1}    (CONFIGURED)(ACTIVATED)(ACTIVE)          
     #Run Keyword If    ${result1}    Pass Execution If  ${result1}  MADIPA is installed          
     #...    ELSE  Log    MADIPA-DB is not installed 
     @{result_list}=    Create List    
     Run Keyword If    ${result1} and ${result2}    Append To List  ${result_list}    MADIPA and MADIPA-DB are installed successfully
     ...    ELSE IF    '${result1}' == 'True' and '${result2}' == 'False'   Append To List  ${result_list}  MADIPA-DB is not installed
     ...    ELSE IF    '${result1}' == 'False' and '${result2}' == 'True'  Append To List  ${result_list}  MADIPA is not installed 
     ...    ELSE    Append To List   ${result_list}   MADIPA and MADIPA-DB are not installed
      Run Keyword If    ${result1} and ${result2}  log  ${result_list} 
      ...   ELSE  Fail  ${result_list}
  
     

