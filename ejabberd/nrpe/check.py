#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

"""
Nagios plugin to check XMPP functionality.
"""
__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import logging

import nagiosplugin
import sleekxmpp

from pysc import nrpe

log = logging.getLogger('nagiosplugin.ejabberd.check_xmpp')


class SendMsg(sleekxmpp.ClientXMPP):

    def __init__(self, jid, password, recipient, message):
        sleekxmpp.ClientXMPP.__init__(self, jid, password)

        self.recipient = recipient
        self.msg = message
        self.add_event_handler("session_start", self.start)

    def start(self, event):
        self.send_presence()
        self.get_roster()

        self.send_message(mto=self.recipient,
                          mbody=self.msg,
                          mtype='chat')

        self.disconnect(wait=True)


class XMPPCheck(nagiosplugin.Resource):

    def __init__(self, jid, password, address=None, use_tls=True):
        self._jid = jid
        self._password = password
        if address:
            self._address = (address, 5222)
        self._use_tls = use_tls
        self.state = nagiosplugin.state.Ok
        self.error = ""

    def probe(self):
        log.info("XMPPCheck.probe started")
        xmpp = SendMsg(
            self._jid, self._password, self._jid, 'a test message')

        def raise_failed_auth(event):
            log.warn("XMPPCheck authentication failed")
            xmpp.disconnect(wait=False)
            self.state = nagiosplugin.state.Critical
            self.error = "Authentication failed."

        if xmpp.connect(
                reattempt=False, address=self._address, use_tls=self._use_tls):
            xmpp.add_event_handler("failed_auth", raise_failed_auth)
            log.info("XMPPCheck connected to server")
            try:
                xmpp.process(block=True)
            except sleekxmpp.exceptions.XMPPError as err:
                self.state = nagiosplugin.state.Critical
                self.error = "Error occurs: {}".format(err)
        else:
            log.debug(
                "Could not connect, jid: {}, password: {}.".format(
                    self._jid, self._password))
            self.state = nagiosplugin.state.Critical
            self.error = "Could not connect to XMPP server."
        return [nagiosplugin.Metric(
            'xmpp', self.state, context='xmpp')]


class XMPPContext(nagiosplugin.Context):

    def evaluate(self, metric, resource):
        if metric.value == nagiosplugin.state.Ok:
            result = self.result_cls(
                nagiosplugin.state.Ok,
                hint="your message is successfully sent.",
                metric=metric)
        else:
            result = self.result_cls(
                nagiosplugin.state.Critical,
                hint=getattr(resource, 'error', ''),
                metric=metric)
        return result


def check_xmpp(config):
    return(
        XMPPCheck(
            jid=config['jid'], password=config['password'],
            address=config['address'], use_tls=config['use_tls']
        ),
        XMPPContext('xmpp')
    )

if __name__ == '__main__':
    nrpe.check(check_xmpp, {})
