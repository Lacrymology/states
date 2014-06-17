#!/usr/bin/env python2.7
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

import ConfigParser
import imaplib
import logging
import os
import smtplib
import sys
import time
import unittest
import uuid


logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__name__)

parser = ConfigParser.SafeConfigParser()
abspath = os.path.abspath('check_mail_stack.cfg')
read = parser.read(abspath)
if not read:
    log.critical('Missing config file at %s', abspath)
    sys.exit(1)

try:
    WAITTIME = float(parser.get('mail', 'smtp_wait'))
    USERNAME = parser.get('mail', 'username')
    PASSWORD = parser.get('mail', 'password')
    IMAP_SERVER = parser.get('mail', 'imap_server')
    SMTP_SERVER = parser.get('mail', 'smtp_server')
except Exception as e:
    log.critical('Bad config: %s', e, exc_info=True)
    log.critical('Sample config \n%s',
                 '''[mail]
username = admin@example.com
password = securepasswd
imap_server = mail.example.com
smtp_server = mail.example.com
smtp_wait = 7
                 ''')
    sys.exit(1)


def pad_uuid(msg):
    # to make each test unique
    return '. '.join((msg, 'UUID: %s' % uuid.uuid4().hex))


class TestMailStack(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.imap = imaplib.IMAP4_SSL(IMAP_SERVER)
        log.debug('IMAP login: %s', cls.imap.login(USERNAME, PASSWORD))
        cls.smtp = smtplib.SMTP_SSL(SMTP_SERVER, 465)
        log.debug('SMTP EHLO: %s', cls.smtp.ehlo())
        log.debug('SMTP login: %s', cls.smtp.login(USERNAME, PASSWORD))

    def setUp(self):
        self.imap = TestMailStack.imap
        self.smtp = TestMailStack.smtp

    def send_email(self, subject, rcpts, body, _from=USERNAME, wait=0):
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
        self.send_email(subject, [USERNAME], body, wait=WAITTIME)

    def _fetch_msg_in_mailbox(self, msg, mailbox, msg_set, msg_parts):
        log.debug('SELECT %s: %s', mailbox, self.imap.select(mailbox))
        fetched = self.imap.fetch(msg_set, msg_parts)
        log.debug('Fetched: %s', fetched)
        return fetched

    def grep_msg(self, msg, mailbox='INBOX', msg_set='lastest',
                 msg_parts='(BODY[TEXT])'):
        if msg_set == 'latest':
            msg_set = self.imap.select(mailbox)[1][0]

        return (msg in
                self._fetch_msg_in_mailbox(msg, mailbox,
                                           msg_set, msg_parts)[1][0][1])

    def test_send_and_receive_GTUBE_spam_in_spam_folder(self):
        # http://en.wikipedia.org/wiki/GTUBE
        body = ('XJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-'
                'STANDARD-ANTI-UBE-TEST-EMAIL*C.34X')
        self._send_email_for_test('Testing spam with GTUBE', body)
        found = self.grep_msg(body, 'spam', msg_set='latest')
        self.assertTrue(found)

    def test_send_and_receive_email_in_inbox_mailbox(self):
        body = 'Test inbox'
        self._send_email_for_test('Testing send email to INBOX', body)
        found = self.grep_msg(body, 'INBOX', msg_set='latest')
        self.assertTrue(found)

    def test_send_virus_email_and_discarded_by_amavis(self):
        # http://en.wikipedia.org/wiki/EICAR_test_file
        body = ('X5O!P%@AP[4\PZX54(P^)7CC)7}$'
                'EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*')
        self._send_email_for_test('Testing send virus email ', body)
        found = self.grep_msg(body, 'INBOX', msg_set='latest')
        self.assertFalse(found)


if __name__ == "__main__":
    unittest.main()
