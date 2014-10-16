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
import pysc
import pysc.nrpe as bfe

log = logging.getLogger('nagiosplugin')


class PgSQLQuery(nap.Resource):
    def __init__(self, host, user, passwd, database, query):
        self.user = user
        self.passwd = passwd
        self.host = host
        self.database = database
        self.query = query

    def probe(self):
        try:
            c = psycopg2.connect(host=self.host, user=self.user,
                                 passwd=self.passwd, database=self.database)
            cursor = c.cursor()
            records = cursor.execute(self.query)
            log.debug(records)
            log.debug(records.fetch_all())
        except Exception as e:
            log.critical(e)
            records = -1

        return [nap.Metric('record', records, context='records')]


@nap.guarded
@pysc.profile(log=log)
def main():
    argp = bfe.ArgumentParser(description=__doc__)
    args = argp.parse_args()
    config = bfe.ConfigFile.from_arguments(args)
    kwargs = config.kwargs('host', 'user', 'passwd', 'database')
    kwargs['query'] = config.get_argument('query', 'SHOW max_connections;')
    critical = config.get_arguments('critical', '1:')
    check = bfe.Check(PgSQLQuery(**kwargs),
                      nap.ScalarContext('records', critical, critical))
    check.main(args)

if __name__ == "__main__":
    main()
