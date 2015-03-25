#!/usr/local/shinken/bin/python
# Use of this is governed by a license that can be found in doc/license.rst.

"""
Sent shinken notifications
"""
import logging

import pysc
import sleekxmpp

logger = logging.getLogger(__name__)

SERVICE_MESSAGE_FMT = """
Notification Type: {notification_type}
Service: {service_desc}
Host: {host_alias}
Address: {host_address}
State: {service_state}
When: {long_date_time}
Additional Info : {service_output}"""

HOST_MESSAGE_FMT = """
Type: {notification_type}
Host: {host_alias}
State: {host_state}
Address: {host_address}
Info: {host_output}
When: {long_date_time}"""

MUC_DEPRECATED = "Use of send mask waiters is deprecated."


class SleekXMPPMUC(logging.Filter):
    def filter(self, record):
        return not record.getMessage() == MUC_DEPRECATED


class SendMsg(sleekxmpp.ClientXMPP):

    def __init__(self, jid, password, recipients, rooms, message):
        sleekxmpp.ClientXMPP.__init__(self, jid, password)

        self.recipients = recipients
        self.rooms = rooms
        self.message = message
        self.add_event_handler("session_start", self.start)

    def start(self, event):
        self.send_presence()
        self.get_roster()

        for recipient in self.recipients:
            self.send_message(mto=recipient,
                              mbody=self.message,
                              mtype='chat')

        for room in self.rooms:
            self.plugin['xep_0045'].joinMUC(room,
                                            "Shinken Bot",
                                            wait=True)
            self.send_message(mto=room,
                              mbody=self.message,
                              mtype='groupchat')

        self.disconnect(wait=True)


class NotifyByXMPP(pysc.Application):

    def setup_logging(self):
        """
        override pysc.setup_logging to add custom logging filter
        """
        if self.config.get('debug', None):
            return pysc.set_logging_debug()

        try:
            logging.config.dictConfig(self.config['logging'])
            # suppress deprecated warning from sleekxmpp MUC plugin
            for handler in logging.root.handlers:
                handler.addFilter(SleekXMPPMUC())

        except Exception:
            pysc.set_logging_debug()
            raise

    def get_argument_parser(self):
        argp = super(NotifyByXMPP, self).get_argument_parser()
        argp.add_argument(
            "--xmpp-config", help="path to xmpp config file",
            required=True)
        argp.add_argument(
            "--mode", help="send notification for HOST or SERVICE",
            required=True,
        )
        argp.add_argument(
            "--host-address", help="shinken macro HOSTADDRESS",
            default="N/A")
        argp.add_argument(
            "--host-alias", help="shinken macro HOSTALIAS",
            default="N/A")
        argp.add_argument(
            "--host-name", help="shinken macro HOSTNAME",
            default="N/A")
        argp.add_argument(
            "--long-date-time", help="shinken macro LONGDATETIME",
            default="N/A")
        argp.add_argument(
            "--notification-type",
            help="shinken macro NOTIFICATIONTYPE", default="N/A")
        argp.add_argument(
            "--service-desc", help="shinken macro SERVICEDESC",
            default="N/A")
        argp.add_argument(
            "--service-output", help="shinken macro SERVICEOUTPUT",
            default="N/A")
        argp.add_argument(
            "--service-state", help="shinken macro SERVICESTATE",
            default="N/A")
        argp.add_argument(
            "--host-state", help="shinken macro HOSTSTATE",
            default="N/A")
        argp.add_argument(
            "--host-output", help="shinken macro HOSTOUTPUT",
            default="N/A"
        )
        return argp

    def main(self):

        # get XMPP configs
        xmpp_configs = pysc.unserialize_yaml(
            self.config["xmpp_config"], critical=True)
        self._jid = xmpp_configs["jid"]
        self._password = xmpp_configs["password"]
        self._recipients = xmpp_configs["recipients"] \
            if "recipients" in xmpp_configs else []
        self._rooms = xmpp_configs["rooms"] if "rooms" in xmpp_configs else []

        logger.debug("config: %s", self.config)
        mode = self.config["mode"]
        if mode == "service":
            message = SERVICE_MESSAGE_FMT.format(**self.config)
            logger.debug("shinken message: %s", message)
        elif mode == "host":
            message = HOST_MESSAGE_FMT.format(**self.config)
        else:
            raise ValueError("Invalid notification mode: %s", mode)

        # begin sending messages
        xmpp = SendMsg(
            self._jid, self._password, self._recipients, self._rooms, message)
        if self._rooms:
            xmpp.register_plugin('xep_0045')  # MUC plugin
        if xmpp.connect():
            try:
                xmpp.process(block=True)
            except sleekxmpp.exceptions.XMPPError as err:
                logger.error("Could not send message, error: %s", err)
        else:
            logger.error("Could not connect to XMPP server")

if __name__ == '__main__':
    NotifyByXMPP().run()
