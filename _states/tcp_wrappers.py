#-*- encoding: utf-8 -*-

'''
tcp_wrappers state
manage part of content in hosts.allow and hosts.deny
'''

import logging


ALLOW_PATH = '/etc/hosts.allow'
DENY_PATH = '/etc/deny.allow'
log = logging.getLogger(__name__)

def __virtual__():
    '''Explicit return name of state module'''
    return 'tcp_wrappers'


def present(name, type, service):
    '''
    Make sure that entry `service`:`name` is present in hosts.`type` file

    Example:

    192.168.32.12:
      tcp_wrappers:
        - present
        - type: allow
        - service: ftp

    3.3.3.3:
      tcp_wrappers:
        - present
        - type: deny
        - service: http

    '''
    clients = name
    ret = {'name': clients,
           'changes': {},
           'result': False,
           'comment': ''}

    if __opts__['test']:
        return {'name': name,
                'changes': {},
                'result': None,
                'comment': 'client[s] {0} is managed'.format(
                    name)}

    service_clients = "{0} : {1}".format(service, clients)
    path = ALLOW_PATH if type == 'allow' else DENY_PATH

    with open(path, 'a+') as f:
        for line in f.readlines():
            if service_clients == line.strip():
                ret['result'] = True
                ret['comment'] = '{0} is already in {1}'.format(
                        service_clients,
                        path,
                        )
                return ret
        f.write(service_clients + '\n')
        ret['result'] = True
        ret['changes'] = {service_clients: 'appended to {0}'.format(
            path
            )
            }
    return ret

def absent(name, type, service):
    '''
    Make sure entry `service`:`name` does not exist in /etc/hosts.`type` file
    Example::

        123.32.12.12:
          tcp_wrappers:
            - absent
            - type: allow
            - service: ftp
    '''
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': ''}

    if __opts__['test']:
        return {'name': name,
                'changes': {},
                'result': None,
                'comment': 'client[s] {0} is managed'.format(
                    name)}

    service_clients = "{0} : {1}".format(service, name)
    path = ALLOW_PATH if type == 'allow' else DENY_PATH

    lines = []
    with open(path) as f:
        lines = f.readlines()

    ret['comment'] = '{0} is not in {1}'.format(service_clients, path)
    with open(path, 'w') as f:
        for line in lines:
            if line.strip() != service_clients:
                f.write(line)
            else:
                ret['changes'] = {service_clients: 'is removed from {0}'.format(
                    path)}
                ret['result'] = True
                ret['comment'] = ''

    return ret
