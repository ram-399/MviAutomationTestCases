*** Settings ***
Library    SeleniumLibrary 
Resource    ../Resource/pmresources.robot
Resource    ../Resource/pmlocators.robot   

*** Test Cases ***
PMPeriodicalDataInsertion_TC8
    Open Browser To Login Netact Page
    #Sleep    3    
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${accept_btn}
    #Sleep    3 
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${report_btn}
    Wait Until Keyword Succeeds	100s	10s  Click Element    ${performance_manager_btn}