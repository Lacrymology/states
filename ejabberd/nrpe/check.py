#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2014, Diep Pham
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#    2. Redistributions in binary form must reproduce the above
#    copyright notice, this list of conditions and the following
#    disclaimer in the documentation and/or other materials provided
#    with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

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
