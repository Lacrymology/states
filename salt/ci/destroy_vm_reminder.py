#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.

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
__maintainer__ = 'Bruno Clermont, Viet Hung Nguyen, Tomas Neme'
__email__ = 'bruno@robotinfra.com, hvn@robotinfra.com, tomas@robotinfra.com'

import re
import json

from envelopes import Envelope, SMTP
from jinja2 import Template
import requests
from salt.utils.parsers import SaltKeyOptionParser
from salt.key import Key


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
