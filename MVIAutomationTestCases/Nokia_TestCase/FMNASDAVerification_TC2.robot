*** Settings ***
Library      SSHLibrary
Resource    ../Resource/fmresources.robot
Library    String 
Library    Collections  
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections      


*** Test Cases ***
FMNASDAVerification_TC2
     Open Connection And Log In
     ${PCF_output1}=  Execute Command    grep 'com.nsn.netact.nasda.connectivity:PCF' /etc/opt/nokia/oss/nasda/conf/metadata/cmdcon/access/cmdconrelatmx.xml
     Sleep  5
     ${PCF_output2}=    Execute Command    grep 'com.nsn.netact.nasda.connectivity:PCF' /etc/opt/nokia/oss/nasda/conf/metadata/cmdint/access/cmdintrelatmx.xml     
     Log To Console        ${PCF_output1} 
     Log To Console        ${PCF_output2}
   # @{str1}=    Split String    ${output1} 
    #@{NASDA_output}=  Split String    @{str1}[2]    =
     ${result1}=    Run Keyword And Return Status    Should Contain    ${PCF_output1}    CHILD_PCF
     Run Keyword If   ${result1}   Log  NASDA Object CANLOC related cmdconre package is successfully installed!        
     ...    ELSE  fail    NASDA Object CANLOC related cmdconre package not installed on the system.
     
     @{list1}=    Create List    CHILD_FTP     CHILD_SNMP    CHILD_SSH    CHILD_HTTP   
     :FOR    ${cmdintre_value}  IN    @{list1}
     \    ${result2}=   Run Keyword And Return Status    Should Contain    ${PCF_output2}    ${cmdintre_value}   
     
     Run Keyword If   ${result2}   Log  NASDA Object CANLOC related cmdintre package is successfully installed!        
     ...    ELSE  fail    NASDA Object CANLOC related cmdintre package not installed on the system.
        
    #${result}=    Should    ${output}    IXR7250
    #Log To Console    ${result}   
    #Log To Console    NASDA Object IXR7250 is installed successfully on the system.
    #Should Not Contain    ${output}    com.nsn.netact.nasda.connectivity:IXR7250
    #Log To Console    Please install PPCP package on the system.   
    #Run Keyword If    ${result}==None    Log To Console    NASDA Object IXR7250 is installed successfully on the system!
    #...    ELSE    fail   Please install PPCP package on the system.                                     
     
     