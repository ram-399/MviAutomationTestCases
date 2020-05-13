*** Settings ***
Library      SSHLibrary
Resource    ../Resource/fmresources.robot
Variables    ../Resource/parameters.yaml
Library      ExcelLibrary

#Library      SCPLibrary    
Library    String 
Library    Collections
Library    DateTime  
Suite Setup            Open SSH Connection And Login To Server      
Suite Teardown  Run KeyWords
...             Close All Connections    AND
...             Close All Excel Documents

*** Test Cases ***
FMNBIAlarmForwarding_TC11
     
     ${server1}=    Open Connection     ${HOST}    
     Login               ${USERNAME}        ${PASSWORD}
     #${output1}=    Execute Command   whoami
     ${server2}=    Open Connection     ${HOST}
     Login               ${USERNAME}        ${PASSWORD}
     Switch Connection    ${server1}
     ${output1}=    Execute Command   whoami
     Switch Connection    ${server2}
     ${output2}=    Execute Command    date