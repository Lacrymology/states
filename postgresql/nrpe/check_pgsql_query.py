#!/usr/local/nagios/bin/python
# -*- encoding: utf-8
# Use of this is governed by a license that can be found in doc/license.rst.

"""
NRPE script for checking postgresql query
"""

__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import logging

import psycopg2
import nagiosplugin as nap
from pysc import nrpe

log = logging.getLogger('nagiosplugin.postgresql.server.query')


class PgSQLQuery(nap.Resource):
    def __init__(self, host, port, user, passwd, database, query):
        self.user = user
        self.passwd = passwd
        self.host = host
        self.port = port
        self.database = database
        self.query = query

    def probe(self):
        log.debug("PgSQLQuery.probe started")
        try:
            log.debug("connecting with postgresql")
            c = psycopg2.connect(host=self.host, port=self.port,
                                 user=self.user,
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

        log.debug("PgSQLQuery.probe finished")
        log.debug("returning %d", records)
        return [nap.Metric('record', records, context='records')]


def check_pgsql_query(config):
    critical = config['critical']
    return (
        PgSQLQuery(host=config['host'],
                   port=config['port'],
                   user=config['user'],
                   passwd=config['passwd'],
                   database=config['database'],
                   query=config['query']),
        nap.ScalarContext('records', critical, critical)
    )

if __name__ == "__main__":
    nrpe.check(check_pgsql_query, {
        'critical': '1:',
        'port': '5432',
        'query': 'show max_connections;',
    })
