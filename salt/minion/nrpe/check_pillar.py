#!/usr/local/nagios/bin/python2
# -*- coding: utf-8 -*-

'''
NRPE check if pillar for current host can be rendered successfully.
'''

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
__email__ = 'hvn@robotinfra.com'

import json
import logging
import subprocess

import nagiosplugin as nap


logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger('nagiosplugin.salt.minion.pillar_render')


# from pysc import nrpe


class PillarRender(nap.Resource):
    def probe(self):
        get_all_pillar_cmd = 'salt-call pillar.items --out=json'.split()
        out = subprocess.check_output(get_all_pillar_cmd)
        jsonoutput = json.loads(out)
        log.debug(jsonoutput)
        if "_errors" in jsonoutput['local']:
            error = jsonoutput['local']['_errors']
            log.error('Error: %s', error)
            render_errors = 1
        else:
            render_errors = 0
        return [nap.Metric('pillar_render_errors', render_errors,
                           context='errors')]


def check_good_pillar(config):
    return (
        PillarRender(),
    )


if __name__ == "__main__":
    c = nap.Check(PillarRender(),
                  nap.ScalarContext('errors', warning='0:0', critical='0:0'))
    c.main()
    # nrpe.check(check_good_pillar, {})
