# -*- coding: utf-8 -*-

"""
Graylog2 state

.. note:: requires: requests
"""

__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'lacrymology@gmail.com'


import requests


def __virtual__():
    if 'graylog.inputs' not in __salt__:
        return False
    return 'graylog'


def _find_input(title, port):
    """
    Find existing matching inputs
    """
    found = False

    inputs = __salt__['graylog.inputs']()
    for iput in inputs:
        if iput['message_input']['title'] == title:
            found = iput
        if iput['message_input']['attributes']['port'] == port:
            found = iput

        if found:
            break
    return found


def _create_input(name, params, function):
    """
    Generic input test and creation state.

    :param name: the state name
    :param function: The function module name to call.
                     e.g.: ``'graylog.create_gelf_input'``
    param dict params: The kwargs to pass `function`
    """
    ret = {
        'name': name,
        'changes': {},
        'result': True,
        'comment': "",
    }

    found = _find_input(params['title'], params['port'])

    if found:
        ret['comment'] = "Matching Input found: {}".format(found)
        return ret

    # not found, create
    if __opts__['test']:
        ret['comment'] = ("{0} would have been called "
                          "with the following parameters: {1}".format(
                              function, params))
        return ret

    try:
        res = __salt__[function](**params)
    except requests.exceptions.HTTPError, e:
        ret['result'] = False
        ret['changes']['error'] = str(e)
        return ret

    ret['changes'] = res
    return ret


def gelf_input(name, title='gelf', stype="udp", port=12201, creator=None,
               bind_address='0.0.0.0', buffer_size=1048576):
    """
    Makes sure a gelf input in the graylog server with the given parameters
    exists. Works only for UDP and TCP GELF Inputs that run globally.
    Identifies the input by title or port. If either are used, it doesn't do
    anything.

    :param title: Descriptive name of the node. Defaults to 'gelf'
    :param stype: Socket type. One of ['tcp', 'udp']. Defaults to udp
    :param port: Port to listen on. Default 12201
    :param creator: The user ID for the creator of this input. Defaults to the
                    admin user.
    :param bind_address: Address to listen on
    :param buffer_size: The size in bytes of the recvBufferSize for network
                        connections to this input. Default 1048576
    """
    params = dict(
        title=title, stype=stype, port=port, creator=creator,
        bind_address=bind_address, buffer_size=buffer_size)

    return _create_input(name, params, 'graylog.create_gelf_input')


def syslog_input(name, title='gelf', stype="udp", port=1514, creator=None,
                 bind_address='0.0.0.0', buffer_size=1048576,
                 allow_override_date=True, store_full_message=False,
                 force_rdns=False):
    """
    Makes sure a gelf input in the graylog server with the given parameters
    exists. Works only for UDP and TCP GELF Inputs that run globally.
    Identifies the input by title or port. If either are used, it doesn't do
    anything.

    :param title: Descriptive name of the node. Defaults to 'gelf'
    :param stype: Socket type. One of ['tcp', 'udp']. Defaults to udp
    :param port: Port to listen on. Default 12201
    :param creator: The user ID for the creator of this input. Defaults to the
                    admin user.
    :param bind_address: Address to listen on
    :param buffer_size: The size in bytes of the recvBufferSize for network
                        connections to this input. Default 1048576
    :param allow_override_date: Allow to override with current date if date
                                could not be parsed
    :param store_full_message: Store the full original syslog message as
                               ``full_message``
    :param force_rdns: Force rDNS resolution of hostname? Use if hostname
                       cannot be parsed
    """
    params = dict(
        title=title, stype=stype, port=port, creator=creator,
        bind_address=bind_address, buffer_size=buffer_size,
        allow_override_date=allow_override_date,
        store_full_message=store_full_message, force_rdns=force_rdns)

    return _create_input(name, params, 'graylog.create_syslog_input')


def stream(
        name, description='', creator=None, rules=[],
        receivers_type="emails", receivers=[]):
    """
    Makes sure that a stream with the given parameters exists.
    Do nothing if a streams with same title exists.
    :param title: Descriptive name of the stream.
    :param description: Description of the stream. Defaults to empty string.
    :param creator: Name of the creator. Default to name of the auth user.
    :param rules: rules to add to the stream.
                  syntax: [{"field": "source", "value": "aaaa",
                            "inverted": false, "type": 1}]
    :receivers_type: "emails" or "users". Default to "emails".
    :receivers: List of alerts receivers of the streams. Default to [].

    """

    ret = {
        'name': name,
        'changes': {},
        'result': True,
        'comment': "",
    }

    # Check if stream with same title exists
    streams = __salt__['graylog.streams']()
    for stream in streams:
        if stream['title'] == name:
            ret['comment'] = "Matching Stream found: {}".format(stream)
            return ret

    params = dict(
        title=name, description=description, creator=creator,
        rules=rules, receivers=receivers,
    )

    if __opts__['test']:
        ret['comment'] = ("graylog.create_stream would have been called "
                          "with the following parameters: {}".format(
                              params))
        return ret

    try:
        res = __salt__['graylog.create_stream'](**params)
    except requests.exceptions.HTTPError, e:
        ret['result'] = False
        ret['changes']['error'] = str(e)
        return ret

    ret['changes'] = res
    return ret
