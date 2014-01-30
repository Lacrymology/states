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
    key = Key(parser.config)
    key_list = key.name_match("integration-dev-*-*")

    vms = {}
    rxp = re.compile(r'integration-dev-(?P<user>.*)-(?P<build>[0-9])')
    for status, keys in key_list.items():
        for key in keys:
            m = rxp.match(key)
            if m:
                user = m.group("user")
                if user not in vms:
                    vms[user] = []
                vms[user].append(key)

    for user, keys in vms.items():
        template = Template(u"""
{{ name }}:

You have the following VMs open:{% for vm in vms %}
- {{ vm }}{% endfor %}

Please go to
{{ url }}
and destroy them if you're done with them

Admin
        """)

        res = requests.get(("http://ci.bit-flippers.com/securityRealm/user/"
                            "{user}/api/json").format(user=user))
        data = json.loads(res.content)
        name = data['fullName']
        email = ''
        for property in data['property']:
            if 'address' in property:
                email = property['address']
                break

        message = template.render(
            name=name, vms=keys,
            url="http://ci.bit-flippers.com/job/-dev-vm-destroy-/build?delay=0sec")

        envelope = Envelope(
            from_addr="noreply@bit-flippers.com",
            to_addr=(email, name),
            subject=u'Please remember to destroy your vms',
            text_body = message,
        )
        envelope.send("smtp.bit-flippers.com")

if __name__ == '__main__':
    import sys
    main(*sys.argv[1:])
