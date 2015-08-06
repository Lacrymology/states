#!/usr/bin/env python
# -*- coding: utf-8 -*-
# {{ salt['pillar.get']('message_do_not_modify') }}
# Use of this is governed by a license that can be found in doc/license.rst.


"""
RavenMail: Emulate /usr/bin/mail(x) but send mail to a Sentry server instead.
"""

import os
import sys
import re

import pysc


class Mail(pysc.Application):
    """
    Send an email
    """
    def get_argument_parser(self):
        argp = super(Mail, self).get_argument_parser()
        argp.add_argument('-s', '--subject', help="Subject")
        argp.add_argument('extra_args', nargs='*')
        # cron calls /usr/bin/sendmail with args: -i -FCronDaemon -oem root
        # handle all other /usr/bin/sendmail args or argparse will fail.
        # generated options list from
        # man 1 sendmail (pkg sendmail 8.14.4-2ubuntu2.1)
        # man sendmail | sed -e '1,/Parameter/d' -e '/Options/,$ d' | awk '{print $1}' | grep '-' | grep -E '\-[a-zA-Z]{1}$' | tr -d '-' | tr -d '\n' # noqa
        store_true_args = 'DGiLNnORtVvX'
        # man sendmail | sed -e '1,/Parameter/d' -e '/Options/,$ d' | awk '{print $1}' | grep '-' | grep -E '\-[a-zA-Z]{1}$' -v | grep -oE '\-[a-za-Z]' | tr -d '-' | uniq | tr -d '\n' # noqa
        # removed -h because it conflict with argparse default option.
        options_args = 'ABbCdFfopqQr'
        for arg in store_true_args:
            argp.add_argument('-' + arg, action='store_true')
        for arg in options_args:
            argp.add_argument('-' + arg)

        argp.add_argument('extra_args', nargs='*')
        # do not use parse_known_args() here because parsing done by pysc
        return argp

    def main(self):
        # consume standard input early
        lines = []
        p = re.compile("Subject: Cron <[^@]+@[^ ]+> (.*)")
        mail_subject = 'This mail has no subject.'
        for line in sys.stdin:
            line = line.rstrip()
            lines.append(line)
            if line.startswith('Subject:'):
                mail_subject = line
                # Removes hostname from cron subject to aggregate sentry events
                if p.search(line):
                    cron_subject = p.search(line).group(1)
                    mail_subject = "Subject: Cron {0}".format(cron_subject)

        body = os.linesep.join(lines)
        if not len(body):
            sys.stderr.write("Empty stdin, nothing to report")
            sys.stderr.write(os.linesep)
            sys.exit(1)

        # init raven quickly, so if something is wrong it get logged early
        from raven import Client
        dsn = self.config['sentry_dsn']
        if not dsn.startswith("requests+"):
            dsn = "requests+" + dsn
        client = Client(dsn=dsn)

        if self.config['subject']:
            subject = self.config['subject']
        else:
            subject = mail_subject
        msg = os.linesep.join((subject, body))
        client.captureMessage(msg, extra=os.environ)

if __name__ == "__main__":
    try:
        Mail().run()
    except Exception as e:
        # pysc log will not work here, initialize and use new one.
        # only doing it here, or it might affect pysc's logging feature.
        import logging
        import logging.handlers
        log = logging.getLogger('raven.mail')
        syslog = logging.handlers.SysLogHandler()
        syslog.setFormatter(logging.Formatter("%(name)s %(message)s"))
        log.addHandler(syslog)
        log.setLevel(logging.ERROR)

        log.error(e, exc_info=True)
