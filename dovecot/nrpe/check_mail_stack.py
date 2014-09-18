#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2014, Hung Nguyen Viet
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# -*- coding: utf-8 -*-

'''
Script for testing functionality of a whole mail stack.
Check send normal mail, spam mail and virus email
'''

__author__ = 'Hung Nguyen Viet <hvnsweeting@gmail.com>'
__maintainer__ = 'Hung Nguyen Viet <hvnsweeting@gmail.com>'
__email__ = 'hvnsweeting@gmail.com'

import imaplib
import logging
import smtplib
import sys
import time
import uuid

import bfs
import nagiosplugin as nap


logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__name__)


def pad_uuid(msg):
    # to make each test unique
    return '. '.join((msg, 'UUID: %s' % uuid.uuid4().hex))


class EmptyMailboxError(Exception):
    pass


class MailStackHealth(nap.Resource):
    def __init__(self,
                 imap_server,
                 smtp_server,
                 username,
                 password,
                 smtp_wait,
                 ssl):

        if ssl:
            self.imap = imaplib.IMAP4_SSL(imap_server)
            self.smtp = smtplib.SMTP_SSL(smtp_server, 465)
        else:
            self.imap = imaplib.IMAP4(imap_server)
            self.smtp = smtplib.SMTP(smtp_server)

        log.debug('IMAP login: %s', self.imap.login(username, password))

        # always recreate `spam` mailbox for clean testing, cannot delete INBOX
        # as IMAP server does not allow doing that.
        log.debug(self.imap.delete('spam'))
        log.debug(self.imap.create('spam'))

        # cleanup all mail existing in INBOX
        self.imap.select('INBOX')
        _, _data = self.imap.search(None, 'ALL')
        for num in _data[0].split():
            self.imap.store(num, '+FLAGS', '\\Deleted')
        self.imap.expunge()
        self.imap.close()

        log.debug('SMTP EHLO: %s', self.smtp.ehlo())
        log.debug('SMTP login: %s', self.smtp.login(username, password))

        self.username = username
        self.password = password
        self.waittime = smtp_wait

    def probe(self):
        inboxtest = self.test_send_and_receive_email_in_inbox_mailbox()
        spamtest = self.test_send_and_receive_GTUBE_spam_in_spam_folder()
        virustest = self.test_send_virus_email_and_discarded_by_amavis()
        return [nap.Metric('mail_stack_health',
                           all((spamtest, inboxtest, virustest)),
                           context='null')]

    def send_email(self, subject, rcpts, body, _from=None, wait=0):
        if _from is None:
            _from = self.username
        msg = '''\
From: %s
Subject: %s

%s
''' % (_from, subject, body)

        ret = self.smtp.sendmail(_from, rcpts, msg)

        time.sleep(wait)
        log.debug('Send mail from %s, to %s, msg %s, return %s',
                  _from, rcpts, msg, ret)

    def _send_email_for_test(self, subject, body):
        body = pad_uuid(body)
        self.send_email(subject, [self.username], body,
                        wait=self.waittime)

    def _fetch_msg_in_mailbox(self, msg, mailbox, msg_set, msg_parts):
        log.debug('SELECT %s: %s', mailbox, self.imap.select(mailbox))
        log.debug('msg_set: %s, msg_parts: %s', msg_set, msg_parts)
        fetched = self.imap.fetch(msg_set, msg_parts)
        log.debug('Fetched: %s', fetched)
        return fetched

    def grep_msg(self, msg, mailbox='INBOX', msg_set='lastest',
                 msg_parts='(BODY[TEXT])'):
        if msg_set == 'latest':
            msg_set = self.imap.select(mailbox)[1][0]

        if int(msg_set) == 0:
            raise EmptyMailboxError('%s is empty, maybe mail processing takes'
                                    ' too long. Consider raising timeout.' %
                                    mailbox)

        return (msg in
                self._fetch_msg_in_mailbox(msg, mailbox,
                                           msg_set, msg_parts)[1][0][1])

    def test_send_and_receive_GTUBE_spam_in_spam_folder(self):
        # http://en.wikipedia.org/wiki/GTUBE
        body = ('XJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-'
                'STANDARD-ANTI-UBE-TEST-EMAIL*C.34X')
        self._send_email_for_test('Testing spam with GTUBE', body)
        found = self.grep_msg(body, 'spam', msg_set='latest')
        return found

    def test_send_and_receive_email_in_inbox_mailbox(self):
        body = 'Test inbox'
        self._send_email_for_test('Testing send email to INBOX', body)
        found = self.grep_msg(body, 'INBOX', msg_set='latest')
        return found

    def test_send_virus_email_and_discarded_by_amavis(self):
        # http://en.wikipedia.org/wiki/EICAR_test_file
        body = ('X5O!P%@AP[4\PZX54(P^)7CC)7}$'
                'EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*')
        self._send_email_for_test('Testing send virus email ', body)
        found = self.grep_msg(body, 'INBOX', msg_set='latest')
        # not found the msg means antivirus worked
        return (not found)


@nap.guarded
@bfs.profile(log=log)
def main():
    try:
        config = bfs.Util('/etc/nagios/check_mail_stack.yml', lock=False)
        mail = config['mail']
        waittime = mail['smtp_wait']
        username = mail['username']
        password = mail['password']
        imap_server = mail['imap_server']
        smtp_server = mail['smtp_server']
        ssl = mail['ssl']
    except Exception as e:
        log.critical('Bad config: %s', e, exc_info=True)
        sys.exit(1)

    mshealth = MailStackHealth(imap_server, smtp_server, username, password,
                               waittime, ssl)
    check = nap.Check(mshealth)
    check.main(timeout=300)

if __name__ == "__main__":
    main()
