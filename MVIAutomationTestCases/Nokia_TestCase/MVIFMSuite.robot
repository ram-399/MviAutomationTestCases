*** Settings ***
Library    SeleniumLibrary 
Library    SSHLibrary 
Library    String       
Resource    ../Resource/fmresources.robot  

*** Test Cases ***
Verify the SSH Connection
    [Tags]    TC1
    Open Connection And Log In
    Sleep    5    
    ${output}=         Execute Command    /opt/cpf/sbin/netact_status.sh status | grep started
    Log     ${output}      
    Should Not Contain    ${output}    stopped 
        
    #Start Command	sudo su
    #${pwd}=	Read Command Output	
    #Log To Console       ${pwd} 
    #Should Be Equal    ${pwd}    root  
  
NASDA_Service_TC2
    [Tags]    TC2
     Open Connection And Log In
    ${output}=    Execute Command    grep 'com.nsn.netact.nasda.connectivity:IXR7250' /etc/opt/nokia/oss/nasda/conf/metadata/cmdcon/access/cmdconrelatmx.xml
    #Log     ${output}  
    #Log To Console        ${output} 
    @{str1}=    Split String    ${output} 
    @{result}=  Split String    @{str1}[2]    =
    #Log To Console    @{result}[1] 
    #Exit For Loop If  @{result}[1]==com.nsn.netact.nasda.connectivity:IXR7250
    #\    Log To Console        NASDA Object IXR7250 is installed successfully on the system. 
    Run Keyword If    @{result}[1]=="${Package_Value}"    Log To Console    NASDA Object IXR7250 is installed successfully on the system!
    ...    ELSE    Log To Console   Please install PPCP package on the system.         
     
     


