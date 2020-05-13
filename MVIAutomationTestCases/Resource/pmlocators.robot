*** Settings ***
Library    SeleniumLibrary    

*** Variables ***
#------------TC5-------------
${login_btn}    xpath://input[@id='login:loginButton']
${accept_btn}    xpath://*[@id="login:legalPanelCloseButton"]
${security_tab}    xpath://*[@id="calypso-container"]/div[2]/div/a[5]/div/span
${security_tab1}    xpath://*[@id="calypso-container"]/div[2]/div/a[26]/div/span[1]
${inputext_ele}    xpath://input[@id='credentialList:dataTable:cneFilterBox']
${enter_key}    xpath://input[@id='credentialList:dataTable:cneFilterBox']
${Adaption_textele}    //td[@id='credentialList:dataTable:0:0:networkElementFqdn']
${report_btn}    xpath://*[@id="calypso-container"]/div[2]/div/a[4]
${performance_manager_btn}    xpath://*[@id="calypso-container"]/div[2]/div/a[29]