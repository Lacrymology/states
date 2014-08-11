#!/usr/local/nagios/bin/python
# -*- encoding: utf-8

"""
NRPE script for checking mysql query
"""

# Copyright (c) 2014, Hung Nguyen Viet All rights reserved.
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

__author__ = 'Hung Nguyen Viet'
__maintainer__ = 'Hung Nguyen Viet'
__email__ = 'hvnsweeting@gmail.com'

import argparse
import logging

import yaml
import pymysql
import nagiosplugin as nap


log = logging.getLogger('nagiosplugin')


class MysqlQuery(nap.Resource):
    def __init__(self, host, user, passwd, database, query):
        self.user = user
        self.passwd = passwd
        self.host = host
        self.database = database
        self.query = query

    def probe(self):
        try:
            c = pymysql.connect(self.host, self.user,
                                self.passwd, self.database)
            cursor = c.cursor()
            records = cursor.execute(self.query)
            log.debug(records)
            log.debug(cursor.fetchall())
        except Exception as e:
            log.critical(e)
            records = -1

        return [nap.Metric('records', records, context='records')]


@nap.guarded
def main():
    argp = argparse.ArgumentParser(description=__doc__)
    argp.add_argument('-f', '--formula', metavar='PATH',
                      help='path to config file')
    argp.add_argument('-d', '--database', metavar='DATABASE',
                      help='database name')
    argp.add_argument('-v', '--verbose', action='count', default=0,
                      help='increase output verbosity (use up to 3 times)')
    argp.add_argument('-c', '--critical', metavar='RANGE', default='1:',
                      help='return critical if number of queried records\
                            is outside of RANGE')
    argp.add_argument('-q', '--query', default='select @@max_connections;',
                      help='SQL query to execute')
    args = argp.parse_args()

    config = yaml.safe_load(args.config)
    dbkey = '%s_mysql' % args.database
    try:
        dbconfig = config[dbkey]
    except KeyError:
        log.critical('Please provide a valid database name')
        # TODO EXIT

    kwargs = {'database': args.databse, 'query': args.query}
    for key in ('passwd', 'user', 'host'):
        yaml_key = '_' + key
        try:
            kwargs[key] = dbconfig[yaml_key]
        except KeyError:
            log.critical("Missing %s key under %s in %s", yaml_key, dbkey,
                         args.config)
            # TODO EXIT
    check = nap.Check(MysqlQuery(**kwargs),
                      nap.ScalarContext('records', args.critical,
                                        args.critical))
    check.main(verbose=args.verbose)


if __name__ == "__main__":
    main()
