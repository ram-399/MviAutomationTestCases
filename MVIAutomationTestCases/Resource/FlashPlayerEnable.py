from selenium import webdriver
from selenium.webdriver.chrome.options import Options


class FlashPlayerEnable(object):

    ROBOT_LIBRARY_VERSION = 1.0

    def __init__(self):
        pass

    def keyword(self):
        options = Options()
        prefs = {
             "profile.default_content_setting_values.plugins": 1,
             "profile.content_settings.plugin_whitelist.adobe-flash-player": 1,
              "profile.content_settings.exceptions.plugins.*,*.per_resource.adobe-flash-player": 1,
              "PluginsAllowedForUrls": "https://clab689lbwas.netact.nsn-rdnet.net"
                }

        options.add_experimental_option("prefs",prefs)
        browser = webdriver.Chrome(options=options)
