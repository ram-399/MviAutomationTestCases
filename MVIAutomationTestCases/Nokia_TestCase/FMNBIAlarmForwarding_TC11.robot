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
     
     write    sudo su
     Read    delay=2s
     Write  ssh ${simulatorip.simulator_ip}
      Read    delay=1s
      Write  cd /home/omc/mdk-snmp-simulator
      Write  cat PCF_New.xml
     ${inputfile}=  Read  delay=2s
     
      Write  java -Djava.endorsed.dirs=. com.nsn.snmp.trap.TrapSimulator ${simulatorip.simulator_ip} 10.32.237.56 162 /home/omc/mdk-snmp-simulator/PCF_New.xml
      Read    delay=1s
      Write  ssh clab689node12
      Write  grep -inr 'pcf' | grep -inr 'Matching alarms size 1' /var/opt/oss/log/nokianetworks-isdk-snmpfm/isdk_snmpfm_debug.log*
      ${output_common}=    Read  delay=10s