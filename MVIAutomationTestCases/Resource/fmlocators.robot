*** Settings ***
Library    SeleniumLibrary    


*** Variables ***

#-------------TC4 &TC5 locators------------
${accept_btn}    xpath://*[@id="login:legalPanelCloseButton"]
${admin_tab}    xpath://*[@id="calypso-container"]/div[2]/div/a[1]/div/span
${adaption_tab}    xpath://span[contains(text(),'Adaptation Manager')]
${inputextfield_search}    xpath://input[@id='search']
${search_btn}    id:searchBtn
${pcf_textele}    xpath://a[@id='adaptationListTable:0:contentIdentificationColumn']
${pcfman_textele}    xpath://tbody[@id='adaptationListTable:tb']//*[@id="adaptationListTable:0:StateColumn"]//span[@id='adaptationListTable:0:contentStatusColumn']
#-----------TC6----------
${security_tab}    xpath://*[@id="calypso-container"]/div[2]/div/a[5]/div/span
${security_tab1}    xpath://*[@id="calypso-container"]/div[2]/div/a[26]/div/span[1]    
${input_text_table}    xpath://input[@id='credentialList:dataTable:cneFilterBox'] 
${vali_field}    //td[@id='credentialList:dataTable:0:0:networkElementFqdn']
#-----------TC10----------
${userassist_tab}    //span[contains(text(),'User Assistance')]
${oib_ele}    xpath://span[contains(text(),'Object Information Browser')]
#${alarm_field}    //*[@id="tabBar__topLevel_4__mouseover"]/table/tbody/tr/td[2]/a
#${alarm_tab}    //*[@id="neDropDown"]
${alarm_mouseover}  //td[@class='notSelected_mouseover']//a[@class='tab'][contains(text(),'Alarms')]
${alarm_mouse}       //td[@class='notSelected']//a[@class='tab'][contains(text(),'Alarms')]
${alarm_tab}        xapth://td[@class='selectedTab']//a[@class='selectedTab'][contains(text(),'Alarms')]

${input_ele}    //input[@name='neDropDown']

