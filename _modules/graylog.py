# -*- coding: utf-8 -*-

"""
Function module to interact with the graylog REST API
"""

__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'lacrymology@gmail.com'

try:
    import requests
except ImportError:
    requests = None

import json


def __virtual__():
    if requests is None:
        return False
    return 'graylog'


def _auth():
    return (
        __salt__['pillar.get']('graylog2:admin_username', 'admin'),
        __salt__['pillar.get']('graylog2:admin_password')
        )


def _base_url():
    return __salt__['pillar.get']('graylog2:rest_listen_uri',
                                  'http://127.0.0.1:12900')


def inputs():
    """
    Return the list
    """
    res = requests.get(_base_url() + '/system/inputs', auth=_auth())
    if res.ok:
        return json.loads(res.content)['inputs']


def _create_input(title, jtype, creator, configuration):
    """
    Creates an input in the graylog server with the given configuration.
    Creates only GLOBAL inputs
    """
    params = {
        'creator_user_id': creator or _auth()[0],
        'title': title,
        'type': jtype,
        'global': True,
        'configuration': configuration,
    }

    res = requests.post(_base_url() + '/system/inputs', data=json.dumps(params),
                        auth=_auth(), headers={
                            'content-type': 'application/json'})
    if res.ok:
        return json.loads(res.content)
    else:
        res.raise_for_status()


def create_gelf_input(title='gelf', stype="udp", port=12201, creator=None,
                      bind_address='0.0.0.0', buffer_size=1048576):
    """
    Creates a gelf input in the graylog server with the given parameters.
    Works only for UDP and TCP GELF Inputs that run globally.

    :param title: Descriptive name of the node. Defaults to 'gelf'
    :param stype: Socket type. One of ['tcp', 'udp']. Defaults to udp
    :param port: Port to listen on. Default 12201
    :param creator: The user ID for the creator of this input. Defaults to the
                    admin user.
    :param bind_address: Address to listen on
    :param buffer_size: The size in bytes of the recvBufferSize for network
                        connections to this input. Default 1048576
    """
    jtypes = {
        'tcp': 'org.graylog2.inputs.gelf.tcp.GELFTCPInput',
        'udp': 'org.graylog2.inputs.gelf.udp.GELFUDPInput',
    }
    jtype = jtypes[stype.lower()]

    configuration = {
        'bind_address': bind_address,
        'port': port,
        'recv_buffer_size': buffer_size
    }

    return _create_input(title, jtype, creator, configuration)


def create_syslog_input(title='syslog', stype="udp", port=1514, creator=None,
                        bind_address='0.0.0.0', buffer_size=1048576,
                        allow_override_date=True, store_full_message=False,
                        force_rdns=False):
    """
    Creates a syslog input in the graylog server with the given parameters.
    Works only for UDP and TCP Syslog Inputs that run globally.

    :param title: Descriptive name of the node. Defaults to 'syslog'
    :param stype: Socket type. One of ['tcp', 'udp']. Defaults to udp
    :param port: Port to listen on. Default 1514
    :param creator: The user ID for the creator of this input. Defaults to the
                    admin user.
    :param bind_address: Address to listen on
    :param buffer_size: The size in bytes of the recvBufferSize for network
                        connections to this input. Default 1048576
    """
    jtypes = {
        'tcp': 'org.graylog2.inputs.syslog.tcp.SyslogTCPInput',
        'udp': 'org.graylog2.inputs.syslog.udp.SyslogUDPInput',
    }
    jtype = jtypes[stype.lower()]

    configuration = {
        'bind_address': bind_address,
        'port': port,
        'recv_buffer_size': buffer_size,
        'allow_override_date': allow_override_date,
        'store_full_message': store_full_message,
        'force_rdns': force_rdns,
    }

    return _create_input(title, jtype, creator, configuration)
