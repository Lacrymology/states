#!/usr/local/nagios/bin/python2
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

"""
NRPE script checks whether encoding of a database is same as expected.
"""

__author__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__maintainer__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__email__ = 'hvn@robotinfra.com'

import logging
import subprocess

import nagiosplugin as nap

from pysc import nrpe

log = logging.getLogger('nagiosplugin.postgresql.common.encoding')


class Encoding(nap.Resource):
    def __init__(self, dbname, encoding):
        self.dbname = dbname
        self.encoding = encoding

    def probe(self):
        '''
        A sample `psql -l` output

          Name    |  Owner   | Encoding  | Collate | Ctype |   Access privileges
        template0 | postgres | SQL_ASCII | C       | C     | =c/postgres          +
                  |          |           |         |       | postgres=CTc/postgres

        '''
        log.debug("Encoding.probe started")
        cmd = ['psql', '-l']
        log.debug(cmd)
        output = subprocess.check_output(cmd).split('\n')
        log.debug(output)
        for line in output:
            cols = line.split(' | ')
            if (self.dbname == cols[0].strip() and
                    self.encoding == cols[2].strip()):
                log.debug(self.dbname)
                log.debug('Expect: {0}, found {1}'.format(self.encoding,
                                                         cols[2].strip()))
                log.debug("Encoding.probe finished")
                log.debug("returning %d", 0)
                return [nap.Metric('encoding', 0, context='encoding')]

        log.debug("Ecoding.probe finished")
        log.debug("returning %d", 1)
        return [nap.Metric('encoding', 1, context='encoding')]


def check_psql_encoding(config):
    """
    Required configurations:
    - ('name', help="The database name to check")
    """
    enc = Encoding(config['name'], config['encoding'])
    return (enc, nap.ScalarContext('encoding', '0:0', '0:0'))


if __name__ == "__main__":
    nrpe.check(check_psql_encoding, {'encoding': 'UTF8'})
