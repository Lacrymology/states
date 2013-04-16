# -*- coding: utf-8 -*-

'''
Amazon Route53 state

requires: http://pypi.python.org/pypi/route53
'''

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
        return False
    return 'route53'

def _connect(access_key, secret_key):
    return route53.connect(aws_access_key_id=access_key, aws_secret_access_key=secret_key)

def records_exists(access_key, secret_key, records):
    '''
    make sure the records are applied to specified AWS account.

    only simple values such as TTL and records/values are supported so far.

    Example:

    mess_with_yahoo_and_google:
      route53.records_exists:
        access_key: xxx
        secret_key: yyy
        records:
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
    conn = _connect(access_key, secret_key)

    for hosted_zone_id in records:
        records_found = {}
        hosted_zone = conn.get_hosted_zone_by_id(hosted_zone_id)
        log.debug("Process hosted zone %s, name: %s", hosted_zone_id,
                  hosted_zone.name)
        for existing in hosted_zone.record_sets:
            existing_type = existing.__class__.__name__.rstrip(
                'ResourceRecordSet').lower()
            log.debug("process existing %s record %s", existing_type,
                      existing.name)
            try:
                records_type = records[hosted_zone_id][existing_type]
            except KeyError:
                # no changes asked for this kind of record
                pass
            else:
                for record in records_type:
                    if existing.name.rstrip('.') == record:
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
                    create_func(record, **kwargs)
                    change_name = '{0} {1} created'.format(record,
                                                           record_type.upper())
                    ret['changes'][change_name] = kwargs
    ret['result'] = True
    return ret

if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    records_exists(
        'AKIAJ6LQJSG6QMTYK7BA',
        'a+2uXD5mWdi6m2JUQ1gbk8Jrhfb47G24Wq+2GOeo',
        {
            'Z2ESDHL401N3AQ': {
                'a': {
                    'logs.microsignage.com': {
                        'values': [
                            '50.19.158.93'
                        ],
                        'ttl': 900
                    }
                }
            }
        }
    )
