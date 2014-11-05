#-*- encoding: utf-8 -*-

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
DNSimple state
requires: requests==1.2.0
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import json
import logging

log = logging.getLogger(__name__)

COMMON_HEADER = {'Accept': 'application/json',
                 'Content-Type': 'application/json',
                 }
BASE_URL = 'https://dnsimple.com'


def _auth_session(email, token):
    import requests
    ses = requests.Session()
    ses.auth = (email, token)
    ses.headers.update(COMMON_HEADER)
    ses.headers.update({'X-DNSimple-Token': email + ":" + token})
    return ses


def created(name, email, token):
    '''
    Create/Register domain name.

    sls example

    example.com:
      dnsimple:
        - registered
        - email: xxx
        - token: xxx
    '''
    domain = name
    ret = {'name': domain,
           'changes': {},
           'result': False,
           'comment': ''}

    if __opts__['test']:
        return {'name': name,
                'changes': {},
                'result': None,
                'comment': 'Domain {0} is set to be created'.format(
                    name)}

    path = "/domains"
    try:
        ses = _auth_session(email, token)
    except ImportError:
        ret['result'] = False
        ret['comment'] = "Python library 'requests' is missing"
        return ret
    data = {"domain": {"name": domain}}
    resp = ses.post(BASE_URL + path, json.dumps(data))
    log.info("{0} {1}".format(resp.status_code, resp.content))
    if resp.status_code == 201:
        ret['result'] = True
        ret['changes'][domain] = "Created in your account"
    elif resp.status_code == 400:
        comment = "already in your account."
        if comment in resp.content:
            ret['result'] = True
            ret['comment'] = comment
    else:
        ret['result'] = False
        if resp.status_code == 401:
            ret['comment'] = 'Unauthorized: bad email and/or token'
        else:
            ret['comment'] = "{0} {1}".format(resp.status_code, resp.content)
    return ret


def _normalize(records):
    '''Return a data with structure same as which returned from API'''
    ret = {}
    for domain in records:
        li = []
        for rectype in records[domain]:
            recs = records[domain][rectype]
            for recname in recs:
                data = {
                    'record_type': rectype,
                    'name': recname
                }
                data.update(recs[recname])
                li.append(data)
        ret[domain] = li
    return ret


def records_exists(name, email, token, records):
    '''
    Update records.
    If any error happens, no changes are applied.

    sls example

    state_name:
      dnsimple.records_exists:
      - email: xxx
      - token: xxx
      - records:
          blahblah.com:
            A:
              www:
                content: 123.11.1.11
                ttl: 123
                prio: 2
              blog:
                content: 122.2.2.2
          adomain.org:
            A:
              www:
                content: 12.1.1.2
                ...
    '''

    ret = {'name': 'existed',
           'changes': {},
           'result': True,
           'comment': ''}

    if records is None:
        ret['result'] = False
        ret['comment'] = "jinja indentation for records argument need more " \
                         "than 2 spaces indentation"
        return ret

    try:
        ses = _auth_session(email, token)
    except ImportError:
        ret['result'] = False
        ret['comment'] = "Python library 'requests' is missing"
        return ret
    existing_records = {}
    for domain in records:
        path = "/domains/{0}/records".format(domain)
        data = json.loads(ses.get(BASE_URL + path).content)
        if 'error' in data:
            ret['result'] = False
            ret['comment'] = '{0}: {1}'.format(domain, data['error'])
            return ret
        data = [i['record'] for i in data]
        existing_records[domain] = data

    to_update = {}
    to_create = {}
    new_records = _normalize(records)
    id2erc = {}
    for domain in records:
        ex_records = existing_records[domain]
        new_domain_records = new_records[domain]
        to_update[domain] = {}
        for nrc in new_domain_records:
            need_create = True
            for erc in ex_records:
                if nrc['name'] == erc['name']:
                    # some records have same name, check their type for making
                    # sure correct update/create
                    # (DNSimple default have 4 NS record with name '')
                    if erc['name'] == '':
                        if erc['record_type'] != nrc['record_type']:
                            continue

                    id2erc[erc['id']] = erc
                    diff = {}
                    for k, v in nrc.items():
                        if erc[k] != v:
                            diff[k] = v

                    if diff != {}:
                        to_update[domain][erc['id']] = diff
                    need_create = False
                    break
            if need_create:
                if to_create == {}:
                    to_create[domain] = []
                to_create[domain].append(nrc)
    log.info("To create: {0}".format(to_create))
    log.info("To update: {0}".format(to_update))

    if __opts__['test']:
        return {'name': name,
                'changes': {},
                'result': None,
                'comment': 'Records {0} is set to be created\nRecords {1} is \
                            set to be updated'.format(to_create, to_update)}

    for domain in to_create:
        for r in to_create[domain]:
            path = "/domains/{0}/records".format(domain)
            data = {"record": r}
            resp = ses.post(BASE_URL + path, json.dumps(data))
            log.info("{0} {1}".format(resp.status_code, resp.content))
            if resp.status_code == 201:
                ret['changes']["{0}:{1}".format(domain, r['name'])] = "created"
            elif resp.status_code == 400:
                ret['result'] = False
                ret['comment'] = resp.content
                return ret
            elif resp.status_code == 404:
                if "Couldn\'t find Domain with name" in resp.content:
                    ret['result'] = False
                    ret['comment'] = "Couldn't find domain {0}".format(domain)
                    return ret
            else:
                ret['result'] = False
                ret['comment'] = "{0} {1} {2}".format(domain, r,
                                                      resp.status_code)
                return ret

    for dom in to_update:
        for rid in to_update[dom]:
            path = "/domains/{0}/records/{1}".format(dom, rid)
            record_changes = to_update[dom][rid]
            resp = ses.put(BASE_URL + path,
                           json.dumps({"record": record_changes}))
            log.info("{0} {1}".format(resp.status_code, resp.content))
            if resp.status_code == 200:
                changes = []
                for k, v in record_changes.items():
                    changes.append("{0}: {1} => {2}".format(
                                   k,
                                   id2erc[rid][k],
                                   json.loads(resp.content)['record'][k]))
                ret['changes']["{0} {1}".format(dom,
                                                id2erc[rid]['name'])] = changes
            else:
                ret['result'] = False
                ret['comment'] = "{0} {1}".format(resp.status_code,
                                                  resp.content)
    return ret
