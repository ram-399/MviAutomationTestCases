__author__ = 'jvalihar'
import os
try:
    from robot.api import logger
    from SSHLibrary import SSHLibrary
    import paramiko
    from scp import SCPClient
except ImportError:
    raise ImportError("Importing required classes failed.")

class NeVeSSHLib(SSHLibrary):

    def __init__(self):
        super(self.__class__, self).__init__()
        self.HIST_FILE = "$HOME/.bash_ta_history"
        self._scp = None
        self._username = {}

    def open_ssh_connection_to_host_with_password(self, host_address, username, password, alias=None, prompt="$", timeout="5 minutes"):
        """Establishes ssh-connection to given host with given credentials. Also changes command history file."""
        self.set_default_configuration(loglevel="trace")
        self.open_connection(host=host_address, alias=alias, prompt=prompt, timeout=timeout)
        self.login(username, password)
        self.set_history_file(self.HIST_FILE)
        connection = self.get_connection()
        self._username[connection.index] = username

    def execute_command_over_ssh_get_rc_and_output(self, command):
        """Executes given command over ssh-connection and removes prompt line and new mail notification from command output."""
        output = self.execute_command(command)
        rc = self.execute_command("echo $?")
        rc_and_output = 	[rc, output]
        return rc_and_output

    def change_to_root_user(self, root_password, prompt="# "):
        """Changes to root user"""
        self.change_to_user("root", root_password, prompt)

    def change_to_user(self, username, password, prompt="$"):
        """Changes to given user"""
        logger.debug("username: " + username)
        logger.debug("password: " + password)
        logger.debug("  prompt: " + prompt)
        self.write("su - " + username)
        self.set_client_configuration(prompt=":")
        self.read_until_prompt()
        self.write(password)
        self.set_client_configuration(prompt=prompt)
        self.read_until_prompt(loglevel="info")
        self.set_history_file(self.HIST_FILE)

    # return_stdout=True, return_stderr=False, return_rc=False
    def execute_command(self, command, loglevel="info"):
        """Executes given command over ssh-connection and removes prompt line and new mail notification from command output."""
        logger.write("<font color=#f0f>Command: </font>" + str(command), loglevel, True)
        self.write(command, loglevel="trace")
        output = self.read_until_prompt(loglevel="trace")
        logger.debug(str(output))
        output = self._drop_prompt_line(output)
        output = self._remove_new_mail_notification(output)
        logger.write("<font color=#f0f>Output: </font>" + str(output), loglevel, True)
        return output

    def set_history_file(self, history_file):
        """Sets command history file for current user."""
        logger.info("Setting command history file to: " + history_file)
        self.write("export HISTFILE=" + history_file)
        self.read_until_prompt(loglevel="trace")

    def scp_put_file(self, source, destination=""):
        """Upload file using SCP"""
        self._get_scp()
        logger.info("<font color=#f0f>     Source: </font>" + source, html=True)
        logger.info("<font color=#f0f>Destination: </font>" + destination, html=True)
        if(destination != ""):
            self._scp.put(source, destination)
        else:
            self._scp.put(source)
        return True

    def scp_get_file(self, source, destination=""):
        """Download file using SCP"""
        self._get_scp()
        logger.info("<font color=#f0f>     Source: </font>" + source, html=True)
        logger.info("<font color=#f0f>Destination: </font>" + destination, html=True)
        if(destination != ""):
            self._scp.get(source, destination)
        else:
            self._scp.get(source)
        return True

    def _get_scp(self):
        connection = self.get_connection()
        login_username = self._username[connection.index]
        current_username = self.execute_command("whoami", "debug")
        if(login_username != current_username):
            raise Exception("Current user is different than the user that logged in. SCP does not support this!")
        connection = self.current
        self._scp = SCPClient(connection.client.get_transport())

    def _drop_prompt_line(self, string):
        idx = string.rfind('[')
        string = string[:idx]
        return string.rstrip('\r\n')

    def _remove_new_mail_notification(self, string):
        idx = string.rfind('You have new mail in')
        if idx != -1:
            string = string[:idx]
            return string.rstrip('\r\n')
        idx = string.rfind('You have mail in')
        if idx != -1:
            string = string[:idx]
            return string.rstrip('\r\n')
        else:
            return string
