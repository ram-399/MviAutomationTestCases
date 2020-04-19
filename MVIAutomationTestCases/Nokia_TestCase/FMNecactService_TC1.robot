*** Settings ***
Library      SSHLibrary
Suite Setup            Open Connection And Log In
Suite Teardown         Close All Connections  

*** Variables ***
${HOST}                10.32.237.58
${USERNAME}            naresh
${PASSWORD}            Nokia_12345

*** Test Cases ***
Verify the SSH Connection
    Open Connection And Log In
    Sleep    5    
    ${output}=         Execute Command    /opt/cpf/sbin/netact_status.sh status | grep started
    Log     ${output}      
    Should Not Contain    ${output}    stopped 
    Execute Command    sudo su     
    #Start Command	sudo su
    #${pwd}=	Read Command Output	
    #Log To Console       ${pwd} 
    #Should Be Equal    ${pwd}    root       
     
     

*** Keywords ***
Open Connection And Log In
   Open Connection     ${HOST}
   Login               ${USERNAME}        ${PASSWORD}