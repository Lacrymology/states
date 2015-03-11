# -*- coding: utf-8 -*-
# Usage of this is governed by a license that can be found in doc/license.rst.

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


def streams():
    """
    Return the list of streams
    """
    res = requests.get(_base_url() + '/streams', auth=_auth())
    if res.ok:
        return json.loads(res.content)['streams']


def create_stream(
        title, description='', creator=None, rules=[],
        receivers_type="emails", receivers=None, alert_grace=1):

    """
    Create a stream.

    :param title: Descriptive name of the stream.
    :param description: Description of the stream. Defaults to empty string.
    :param creator: Name of the creator. Default to name of the auth user.
    :param rules: rules to add to the stream.
                  syntax: [{"field": "source", "value": "aaaa",
                            "inverted": false, "type": 1}]
    :receivers_type: "emails" or "users". Default to "emails".
    :receivers: List of alerts receivers of the streams. Default to None.
    :alert_grace: time (in minutes) to wait until triggering a new
                  alert. Default to 1 minute.
    """

    stream_params = {
        'title': title,
        'description': description,
        'creator_user_id': creator or _auth()[0],
    }

    def raise_if_error(res):
        """
        raise if got error response
        """
        if not res.ok:
            res.raise_for_status()

    res_create_stream = requests.post(
        _base_url() + '/streams',
        data=json.dumps(stream_params), auth=_auth(),
        headers={'content-type': 'application/json'})

    raise_if_error(res_create_stream)

    stream = json.loads(res_create_stream.content)
    stream_id = stream['stream_id']

    res_enable_stream = requests.post(
        _base_url() + '/streams/{}/resume'.format(stream_id),
        auth=_auth(), headers={'content-type': 'application/json'})

    raise_if_error(res_enable_stream)

    for rule in rules:
        res_create_rule = requests.post(
            _base_url() + '/streams/{}/rules'.format(stream_id),
            auth=_auth(), headers={'content-type': 'application/json'},
            data=json.dumps(rule)
        )

        raise_if_error(res_create_rule)

    if not receivers:
        receivers = []

    for receiver in receivers:
        payload = {"entity": receiver, "type": receivers_type}
        res_create_receiver = requests.post(
            _base_url() + '/streams/{}/alerts/receivers'.format(stream_id),
            params=payload, auth=_auth(),
            headers={'content-type': 'application/json'},
        )

        raise_if_error(res_create_receiver)

    alert_condition = {
        "parameters": {
            "grace": 1, "time": 1, "backlog": 100,
            "threshold_type": "more", "threshold": 1
        },
        "type": "message_count",
        "creator_user_id": creator or _auth()[0],
    }

    res_create_alert = requests.post(
        _base_url() + '/streams/{}/alerts/conditions'.format(stream_id),
        auth=_auth(), data=json.dumps(alert_condition),
        headers={'content-type': 'application/json'},
    )

    raise_if_error(res_create_alert)

    return stream


def delete_stream(title):

    """
    Delete a stream with given title.

    :param title: Descriptive name of the stream.
    """
    # Check if stream with same title exists
    is_exist = False
    stream_ids = []
    gl2_streams = streams()
    for stream in gl2_streams:
        if stream['title'] == title:
            is_exist = True
            stream_ids.append(stream['id'])

    if not is_exist:
        return

    for stream_id in stream_ids:
        res_delete_stream = requests.delete(
            _base_url() + '/streams/{}'.format(stream_id),
            auth=_auth(),
            headers={'content-type': 'application/json'})

        if not res_delete_stream.ok:
            res_delete_stream.raise_for_status()
    return {'stream_ids': stream_ids}
