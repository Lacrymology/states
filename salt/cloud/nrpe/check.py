#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-

# Copyright (c) 2014, Tomas Neme
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
Nagios plugin to check that saltcloud images are as listed in the cloud.profile
file
"""
import argparse
import logging
import subprocess
import yaml

__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'lacrymology@gmail.com'

import nagiosplugin
from bfs import nrpe as bfe

log = logging.getLogger("nagiosplugin")

class Summary(nagiosplugin.Summary):
    def ok(self, results):
       return "ok".join(str(r) for r in results)

    def problem(self, results):
        return ";".join(self.format(result) for result in results)

    def format(self, result):
        value = result.metric.value
        count = len(value)
        msg = "is OK"
        if count > 0:
            msg = "%d missing images [%s]" % (count, ", ".join(value))
        return "{metric}: {msg}".format(metric=result.metric.name, msg=msg)

class MissingImageContext(nagiosplugin.Context):
    def describe(self, metric):
        if len(metric.value) > 0:
            return "%d images missing: [%s]" % (len(metric), ", ".join(metric))
        return "No images missing"

    def evaluate(self, metric, resource):
        if len(metric.value) > 0:
            state = nagiosplugin.state.Critical
        else:
            state = nagiosplugin.state.Ok

        return nagiosplugin.Result(state, metric=metric)

class ImageIds(nagiosplugin.Resource):
    """
    Checks the salt-cloud instances list against cloud.profile
    """
    def __init__(self, profile_file, providers_file):
        self.profile_file = profile_file
        self.providers_file = providers_file

    def probe(self):
        # get cloud.profile data
        profile_list = {}
        with open(self.profile_file) as f:
            profile_list = yaml.load(f)

        providers = {}
        with open(self.providers_file) as f:
            providers = yaml.safe_load(f)

        # get salt-cloud output
        try:
            proc = subprocess.Popen(['salt-cloud',
                                     '--list-images=all',
                                     '--out=yaml'],
                                    stdout=subprocess.PIPE)
        except OSError:
            pass
        else:
            salt_list = yaml.load(proc.stdout)

        ids = set()
        # get the providers and their drivers' names and populate a list of ids
        for provider, data in providers.items():
            salt_list_data = salt_list[provider][data['provider']]
            ids.update(str(salt_list_data[inst]['id'])
                       for inst in salt_list_data)
        log.debug("received ids: %s", str(ids))

        imgs = set(str(prof['image']) for prof in profile_list.values())
        log.debug("profile images: %s", str(imgs))
        yield nagiosplugin.Metric('missing', imgs - ids)


@nagiosplugin.guarded
def main():
    argp = bfe.ArgumentParser()
    argp.add_argument("--profile-file", metavar="PATH",
                      default="/etc/salt/cloud.profiles")
    argp.add_argument("--providers-file", metavar="PATH",
                      default="/etc/salt/cloud.providers")
    args = argp.parse_args()

    check = bfe.Check(ImageIds(args.profile_file, args.providers_file),
                               MissingImageContext('missing'),
                               Summary())
    check.main(args)

if __name__ == '__main__':
    main()
