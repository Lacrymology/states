#!/usr/local/nagios/bin/python
# -*- encoding: utf-8

"""
NRPE script for checking postgresql query
"""

# Copyright (c) 2014, Diep Pham All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import logging

import psycopg2
import nagiosplugin as nap
from pysc import nrpe

log = logging.getLogger('nagiosplugin.postgresql.server.query')


class PgSQLQuery(nap.Resource):
    def __init__(self, host, user, passwd, database, query):
        self.user = user
        self.passwd = passwd
        self.host = host
        self.database = database
        self.query = query

    def probe(self):
        log.info("PgSQLQuery.probe started")
        try:
            log.debug("connecting with postgresql")
            c = psycopg2.connect(host=self.host, user=self.user,
                                 password=self.passwd, database=self.database)
            cursor = c.cursor()
            log.debug("about to execute query: %s", self.query)
            cursor.execute(self.query)
            records = cursor.rowcount
            log.debug("resulted in %d records", records)
            log.debug(records)
            log.debug(cursor.fetchall())
        except psycopg2.Error as err:
            log.critical(err)
            raise nap.CheckError(
                'Something went wrong with '
                'PostgreSQL query operation, Error: {}'.format(err))

        log.info("PgSQLQuery.probe finished")
        log.debug("returning %d", records)
        return [nap.Metric('record', records, context='records')]


def check_pgsql_query(config):
    critical = config['critical']
    return (
        PgSQLQuery(host=config['host'],
                   user=config['user'],
                   passwd=config['passwd'],
                   database=config['database'],
                   query=config['query']),
        nap.ScalarContext('records', critical, critical)
    )

if __name__ == "__main__":
    nrpe.check(check_pgsql_query, {
        'critical': '1:',
        'query': 'show max_connections;',
    })
