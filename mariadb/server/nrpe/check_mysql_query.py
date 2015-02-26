#!/usr/local/nagios/bin/python
# -*- encoding: utf-8
# Use of this is governed by a license that can be found in doc/license.rst.

"""
NRPE script for checking mysql query
"""

__author__ = 'Viet Hung Nguyen'
__maintainer__ = 'Viet Hung Nguyen'
__email__ = 'hvn@robotinfra.com'

import logging

import nagiosplugin as nap
import pymysql
from pysc import nrpe

log = logging.getLogger('nagiosplugin.mysql.query')


class MysqlQuery(nap.Resource):
    def __init__(self, host, user, passwd, database, query):
        log.debug("MysqlQuery(%s, %s, %s, %s)",
                  host, user, database, query)
        self.user = user
        self.passwd = passwd
        self.host = host
        self.database = database
        self.query = query

    def probe(self):
        log.debug("MysqlQuery.probe started")
        try:
            log.debug("connecting with pymysql")
            c = pymysql.connect(self.host, self.user,
                                self.passwd, self.database)
            cursor = c.cursor()
            log.debug("about to execute query: %s", self.query)
            records = cursor.execute(self.query)
            log.debug("resulted in %d records", records)
            log.debug(cursor.fetchall())
        except pymysql.err.Error as err:
            log.critical(err)
            raise nap.CheckError(
                'Something went wrong with '
                'MySQL query operation, Error: ()'.format(err))

        log.debug("MysqlQuery.probe finished")
        log.debug("returning %d", records)
        return [nap.Metric('records', records, context='records')]


def check_mysql_query(config):
    critical = config['critical']
    return (
        MysqlQuery(host=config['host'],
                   user=config['user'],
                   passwd=config['passwd'],
                   database=config['database'],
                   query=config['query']),
        nap.ScalarContext('records', critical, critical)
    )


if __name__ == "__main__":
    nrpe.check(check_mysql_query, {
        'critical': '1:',
        'query': 'select @@max_connections;',
    })
