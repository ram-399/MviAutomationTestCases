*** Settings ***
Library      SSHLibrary
Library    SeleniumLibrary    

*** Variables ***
${url}    https://clab689lbwas.netact.nsn-rdnet.net/authentication/Login
${browser}    chrome
${HOST}                10.32.237.58
${USERNAME}            naresh
${PASSWORD}            Nokia_12345
${Package_Value}       com.nsn.netact.nasda.connectivity:IXR7250
${Nct_usrxpath}    //input[@id='login:username']
${Nct_pwdxpath}    //input[@id='login:password']
${login_ele}    //input[@id='login:loginButton']
${interface}    snmp

*** Keywords ***
Open Connection And Log In
   Open Connection     ${HOST}
   Login               ${USERNAME}        ${PASSWORD}

lanuchBrowser and login
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Click Element    xpath://*[@id="details-button"]
    Click Link    xpath://*[@id="proceed-link"]     
    Sleep    3        
    Input Text    ${Nct_usrxpath}        naresh
    Input Password    ${Nct_pwdxpath}        Nokia_12345
    Click Element     ${login_ele}                            