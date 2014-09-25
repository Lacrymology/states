#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2013, Tomas Neme
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
This script sends reminders to developers with open dev vms to close them when
they are done with them

This application requires the values below to exist in the salt master
configuration.

The destroy_vm_reminder/email/smtp dictionary is passed as-is to envelope's smtp
instance, see Envelopes documentation for details

The key_regexp must at least contain a group named user (i.e. something of the
form `(?P<user>PATTERN)`), which is used to retrieve the user's email address
from jenkins

Config example
==============

destroy_vm_reminder:
  key_regexp: some-prefix-(?P<user>.*)-some-suffix-[0-9]+
  key_glob: integration-dev-*-*
  jenkins:
    prefix: http://jenkins.example.com
    username: jenkins_username
    # get your api_token from your jenkins profile page
    api_token: 1234567890abcdef1234567890abcdef
  destroy_job: destroy-dev-vm
  email:
    from: admin@example.com
    subject: 'Please remember to destroy your vms'
    smtp:
      host: smpt.example.com
      port: 25
      login: myuser
      password: mypassword
      tls: (boolean)
      timeout: (float)
    message_template: |
                      {{ name }}:

                      You have the following VMs open:{% for vm in vms %}
                      - {{ vm }}{% endfor %}

                      Please go to
                      {{ url }}
                      and destroy them if you're done with them

                      Admin
"""

__author__ = 'Tomas Neme'
__maintainer__ = 'Bruno Clermont, Hung Nguyen Viet, Tomas Neme'
__email__ = 'patate@fastmail.cn, hvnsweeting@gmail.com, lacrymology@gmail.com'

import re
import requests
import json
from jinja2 import Template
from salt.utils.parsers import SaltKeyOptionParser
from salt.key import Key
from envelopes import Envelope, SMTP

def main(*args):
    parser = SaltKeyOptionParser()
    parser.parse_args()
    opts = parser.config
    key = Key(opts)
    my_opts = opts['destroy_vm_reminder']
    key_list = key.name_match(my_opts['key_glob'])

    vms = {}
    rxp = re.compile(my_opts['key_regexp'])
    for status, keys in key_list.items():
        for key in keys:
            m = rxp.match(key)
            if m:
                user = m.group("user")
                if user not in vms:
                    vms[user] = []
                vms[user].append(key)

    smtp = SMTP(**my_opts['email']['smtp'])
    template = Template(my_opts['email']['message_template'])

    for user, keys in vms.items():

        res = requests.get(("{prefix}/securityRealm/user/{user}/api/json").format(
            prefix=my_opts['jenkins']['prefix'], user=user),
                           auth=(my_opts['jenkins']['username'],
                                 my_opts['jenkins']['api_token']))
        data = json.loads(res.content)
        name = data['fullName']
        email = ''
        for property in data['property']:
            if 'address' in property:
                email = property['address']
                break

        message = template.render(
            name=name, vms=keys,
            url="{prefix}/job/{job_name}/build?delay=0sec".format(
                prefix=my_opts['jenkins']['prefix'],
                job_name=my_opts['destroy_job']))

        envelope = Envelope(
            from_addr=my_opts['email']['from'],
            to_addr=(email, name),
            subject=my_opts['email']['subject'],
            text_body = message,
        )
        smtp.send(envelope)

# TODO: switch to pysc.Util
if __name__ == '__main__':
    import sys
    main(*sys.argv[1:])
