# -*- coding: utf-8 -*-

# Copyright (c) 2013, Bruno Clermont
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
Get some grains information that is only available in Amazon AWS

Source: https://github.com/saltstack/salt/issues/1825
"""

__author__ = 'Erik Günther'
__maintainer__ = 'Bruno Clermont'
__email__ = 'patate@fastmail.cn'

import json
import logging
import httplib
import socket
import datetime

# Set up logging
LOG = logging.getLogger(__name__)


def _call_aws(url):
    """
    Call AWS via httplib. require correct path to data will
    Host: 169.254.169.254

    """

    conn = httplib.HTTPConnection("169.254.169.254", 80, timeout=1)
    conn.request('GET', url)
    response = conn.getresponse()
    if response.status != 200:
        return "{}"

    data = response.read()
    return data


def _get_ec2_hostinfo():
    """
    Will return grain information about this host that is EC2 specific

    "kernelId" : "aki-12345678",
    "ramdiskId" : None,
    "instanceId" : "i-12345678",
    "instanceType" : "c1.medium",
    "billingProducts" : None,
    "architecture" : "i386",
    "version" : "2010-08-31",
    "accountId" : "123456789012",
    "imageId" : "ami-12345678",
    "availabilityZone" : "eu-west-1a",
    "pendingTime" : "2012-07-10T03:54:24Z",
    "devpayProductCodes" : None,
    "privateIp" : "10.XX.YY.ZZ",
    "region" : "eu-west-1",
    "local-ipv4" : "10.XX.YY.ZZ",
    "local-hostname" : "ip-10-XX-YY-ZZ.eu-west-1.compute.internal",
    "public-ipv4" : "AA.BB.CC.DD",
    "public-hostname" : "ec2-AA-BB-CC-DD.eu-west-1.compute.amazonaws.com"
    """

    grains = {}
    #Read the buffert, and convert it to a dict
    data = _call_aws("/latest/dynamic/instance-identity/document")
    #null isn't None so translate on the fly
    grains = json.loads(data)

    #Add some more default data
    grains['local-ipv4'] = _call_aws("/latest/meta-data/local-ipv4")
    grains['local-hostname'] = _call_aws("/latest/meta-data/local-hostname")

    grains['public-ipv4'] = _call_aws("/latest/meta-data/public-ipv4")
    grains['public-hostname'] = _call_aws("/latest/meta-data/public-hostname")
    grains['is_on_ec2'] = True

    return grains


def ec2_info():
    """
    Collect some extra host information
    """
    empty = {'is_on_ec2': False}
    try:
        #First do a quick check if AWS magic URL work. If so we guessing that
        # we are running in AWS and will try to get more data.
        _call_aws('/')
    except:
        return empty

    try:
        grains = _get_ec2_hostinfo()
        if not grains:
            return empty
        return grains
    except socket.timeout, serr:
        LOG.info("Could not read EC2 data: %s" % (serr))
        return empty


def boot_datetime(proc_filename='/proc/uptime'):
    """
    When this host booted
    :return: exact time with microseconds precision when this host had booted
    :rtype: :class:`datetime.datetime`
    """
    uptime_file_handler = open(proc_filename, 'r')
    now = datetime.datetime.now()
    uptime_seconds = float(uptime_file_handler.readline().split()[0])
    delta = datetime.timedelta(seconds=uptime_seconds)
    return now - delta


if __name__ == "__main__":
    print ec2_info()
