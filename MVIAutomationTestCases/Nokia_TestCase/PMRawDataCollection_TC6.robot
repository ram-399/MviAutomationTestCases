*** Settings ***
Library      SSHLibrary
Resource    ../Resource/pmresources.robot
Variables    ../Resource/parameters.yaml
Library    String 
Library    Collections  
Suite Setup            Open SSH Connection And Login To Server  ${clab689_info.host_ip}  ${clab689_info.user_name}  ${clab689_info.password}
Suite Teardown         Close All Connections      


*** Test Cases ***
PMRawDataCollection_TC6
    [Documentation]    PMRawDataCollection   
    [Tags]    TC_6
     Change Root User
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
     Get Common Mediation Node 
     Write   ${rawfile_dir} 
     Write   ls -lrt  
     ${pdf_output}=    Read    delay=5s 
     ${result}=    Run Keyword And Return Status    Should Contain    ${pdf_output}    A20200417.0755+0200-0800+0205.xml        
     Run Keyword If    ${result}    Log    Raw Data file is copined into the desired location!        
     ...    ELSE  fail    Raw Data file is not copined into the desired location! 