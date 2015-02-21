#!/usr/local/nagios/bin/python
# -*- coding: utf-8 -*-
# {{ salt['pillar.get']('message_do_not_modify') }}
# Use of this is governed by a license that can be found in doc/license.rst.

"""
Nagios plugin to check that saltcloud images are as listed in the cloud.profile
file
"""

__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'tomas@robotinfra.com'

import logging
import subprocess

import nagiosplugin
import yaml

import pysc
from pysc import nrpe

log = logging.getLogger("nagiosplugin.salt.cloud.images")


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
        log.debug("ImageIds(%s, %s)", profile_file, providers_file)
        self.profile_file = profile_file
        self.providers_file = providers_file

    def probe(self):
        log.info("ImageIds.probe started")
        profile_list = pysc.unserialize_yaml(self.profile_file, critical=True)
        providers = pysc.unserialize_yaml(self.providers_file, critical=True)

        # get salt-cloud output
        proc = subprocess.Popen(['salt-cloud',
                                 '--list-images=all',
                                 '--out=yaml'],
                                stdout=subprocess.PIPE)
        salt_list = yaml.load(proc.stdout)
        log.debug("salt list: %s", str(salt_list))

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
        log.info("ImageIds.probe ended")


def check_saltcloud_images(config):
    return (
        ImageIds(config['profile_file'],
                 config['providers_file']),
        MissingImageContext('missing'),
        Summary())


if __name__ == '__main__':
    nrpe.check(check_saltcloud_images, {
        'profile_file': '/etc/salt/cloud.profiles',
        'providers_file': '/etc/salt/cloud.providers',
    })
