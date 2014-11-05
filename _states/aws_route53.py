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
Amazon Route53 state

requires: http://pypi.python.org/pypi/route53
"""

__author__ = 'Bruno Clermont'
__maintainer__ = 'Bruno Clermont'
__email__ = 'bruno@robotinfra.com'

import logging

try:
    import route53
except ImportError:
    route53 = None

log = logging.getLogger(__name__)


def __virtual__():
    '''
    Verify python-route53 is installed.
    '''
    if route53 is None:
        log.debug("Can't find python module 'route53'")
        return False
    return 'route53'


def _connect(access_key, secret_key):
    return route53.connect(aws_access_key_id=access_key,
                           aws_secret_access_key=secret_key)


def _record_type(record_set):
    return record_set.__class__.__name__.rstrip('ResourceRecordSet').lower()


def record_absent(name, record_type, zone_id, access_key, secret_key):
    '''
    Make sure an Amazon Route53 DNS record is absent.

    Example:

    www.google.com:
      route53.record_absent:
        - type: a
        - zone_id: Z2ESDHL3365N3AQ
        - access_key: xxx
        - secret_key: yyy
    '''

    ret = {'name': 'Record {0} type {1}'.format(name, record_type.upper()),
           'result': None, 'comment': '', 'changes': {}}
    conn = _connect(access_key, secret_key)
    try:
        hosted_zone = conn.get_hosted_zone_by_id(zone_id)
    except Exception, err:
        log.error("Can't get zone info: %s", str(err))
        ret['result'] = False
        ret['comment'] = "Can't connect to Amazon Route 53 (bad user/pass?)"
        return ret
    for record_set in hosted_zone.record_sets:
        if record_set.name.rstrip('.').lower() == name.lower() and \
           _record_type(record_set) == record_type:
            if __opts__['test']:
                ret['comment'] = 'Found and is set to be deleted'
            else:
                record_set.delete()
                ret['changes'][ret['name']] = 'Deleted'
                ret['result'] = True
                ret['comment'] = 'Deleted succesfully'
            return ret
    ret['comment'] = 'Record is already absent'
    ret['result'] = True
    return ret


def records_exists(access_key, secret_key, records):
    '''
    make sure the records are applied to specified AWS account.

    only simple values such as TTL and records/values are supported so far.

    Example:

    mess_with_yahoo_and_google:
      route53.records_exists:
        - access_key: xxx
        - secret_key: yyy
        - records:
           Z2ESDHL3365N3AQ: {# Amazon hosted zone ID #}
             a: {# can be a, aaaa, txt, ns, cname, mx, ptr, spf and srv #}
               .google.com:
                 values: {# set multiple values for round-robin #}
                   - 127.0.0.1
                   - 127.0.0.2
                 ttl: 1200
               www.google.com:
                 values:
                   - 127.0.0.3
           Z2000003365N3AQ:
             cname:
               www.yahoo.com:
                 values:
                   - www.google.com
                 ttl: 1200
    '''
    log.debug("Run records_exists: %s", records)
    ret = {'name': 'records_exists', 'result': None, 'comment': '',
           'changes': {}}
    opposite_types = {'a': 'cname', 'cname': 'a'}

    if records is None:
        ret['result'] = False
        ret['comment'] = "jinja indentation for records argument need more " \
                         "than 2 spaces indentation"
        return ret

    conn = _connect(access_key, secret_key)

    for hosted_zone_id in records:
        records_found = {}
        try:
            hosted_zone = conn.get_hosted_zone_by_id(hosted_zone_id)
        except Exception, err:
            log.error("Can't get zone info: %s", str(err))
            ret['result'] = False
            ret['comment'] = "Can't connect to Amazon Route 53 (bad user/pass?)"
            return ret

        log.debug("Process hosted zone %s, name: %s", hosted_zone_id,
                  hosted_zone.name)
        for existing in hosted_zone.record_sets:
            existing_type = _record_type(existing)
            log.debug("process existing %s record %s", existing_type,
                      existing.name)
            try:
                records_type = records[hosted_zone_id][existing_type]
            except KeyError:
                # no changes asked for this kind of record
                pass
            else:
                for record in records_type:
                    if existing.name.rstrip('.').lower() == record.lower():
                        # keep a reference to found record to not add them at
                        # the ends
                        try:
                            records_found[existing_type].append(record)
                        except KeyError:
                            records_found[existing_type] = [record]

                        log.debug("found a matching record set!")
                        # check if it's the same
                        same = True
                        # check ttl
                        if 'ttl' in records_type[record]:
                            if records_type[record]['ttl'] != existing.ttl:
                                log.debug("TTL is changing %s -> %s",
                                          existing.ttl,
                                          records_type[record]['ttl'])
                                ret['changes']['{0} TTL'.format(record)] =\
                                    '{0} -> {1}'.format(
                                        existing.ttl,
                                        records_type[record]['ttl'])
                                existing.ttl = records_type[record]['ttl']
                                same = False
                        # check records (values)
                        if records_type[record]['values'] != existing.records:
                            log.debug("Record is changing %s -> %s",
                                      existing.records,
                                      records_type[record]['values'])
                            ret['changes']['{0} records'.format(record)] =\
                                '{0} -> {1}'.format(
                                    existing.records,
                                    records_type[record]['values'])
                            existing.records = records_type[record]['values']
                            same = False

                        if same:
                            log.debug("Record set already have good values")
                        else:
                            log.info("Record set don't have the good values")
                            if not __opts__['test']:
                                existing.save()

        # loop into each records for this zone and check if they had been
        # previously found
        for record_type in records[hosted_zone_id]:
            try:
                found = records_found[record_type]
            except KeyError:
                found = []
            for record in records[hosted_zone_id][record_type]:
                # if not found, just create them
                if record not in found:
                    log.info("Can't find %s record with %s, create it",
                             record_type, record)
                    create_func = getattr(hosted_zone,
                                          'create_{0}_record'.format(
                                              record_type))
                    kwargs = records[hosted_zone_id][record_type][record]
                    if not __opts__['test']:
                        try:
                            create_func(record, **kwargs)
                        except Exception:
                            if record_type in opposite_types:
                                # delete the opposite record type format
                                # and try to create it one last time
                                delete = record_absent(
                                    record,
                                    opposite_types[record_type],
                                    hosted_zone_id,
                                    access_key,
                                    secret_key
                                )
                                if delete['result']:
                                    ret['changes'].update(delete['changes'])
                                    try:
                                        create_func(record, **kwargs)
                                    except Exception:
                                        ret['comment'] = \
                                            "Can't create record %s" % record
                                        ret['result'] = False
                                        return ret
                                else:
                                    ret['result'] = False
                                    ret['comment'] = delete['comment']
                                    return ret
                            else:
                                ret['result'] = False
                                ret['comment'] = "Can't create record %s" % \
                                                 record
                                return ret
                    change_name = '{0} {1} created'.format(record,
                                                           record_type.upper())
                    ret['changes'][change_name] = kwargs
    if __opts__['test'] and not ret['changes']:
        ret['result'] = None
    else:
        ret['result'] = True
    return ret
