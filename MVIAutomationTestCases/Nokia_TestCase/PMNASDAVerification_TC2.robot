*** Settings ***
Library      SSHLibrary
Resource    ../Resource/fmresources.robot
Library    String 
Library    Collections  
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections      


*** Test Cases ***
PMNASDAVerification_TC2
     Open Connection And Log In
    ${IPAM_output1}=  Execute Command    grep 'com.nsn.netact.nasda.connectivity:IPAM' /etc/opt/nokia/oss/nasda/conf/metadata/cmdcon/access/cmdconrelatmx.xml
    Sleep  5
    ${IPAM_output2}=    Execute Command    grep 'com.nsn.netact.nasda.connectivity:IPAM' /etc/opt/nokia/oss/nasda/conf/metadata/cmdint/access/cmdintrelatmx.xml     
    Log To Console        ${IPAM_output1} 
    Log To Console        ${IPAM_output2}
   # @{str1}=    Split String    ${output1} 
    #@{NASDA_output}=  Split String    @{str1}[2]    =
     ${result1}=    Run Keyword And Return Status    Should Contain    ${IPAM_output1}    CHILD_IPAM
     Run Keyword If   ${result1}   Log  NASDA Object CANLOC related cmdconre package is successfully installed!        
     ...    ELSE  fail    NASDA Object CANLOC related cmdconre package not installed on the system.
     
     @{list1}=    Create List    CHILD_FTP     CHILD_SNMP    CHILD_SSH    
     :FOR    ${cmdintre_value}  IN    @{list1}
     \    ${result2}=   Run Keyword And Return Status    Should Contain    ${IPAM_output2}    ${cmdintre_value}   
     
     Run Keyword If   ${result2}   Log  NASDA Object CANLOC related cmdintre package is successfully installed!        
     ...    ELSE  fail    NASDA Object CANLOC related cmdintre package not installed on the system.