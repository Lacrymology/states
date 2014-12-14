# -*- coding: utf-8 -*-

"""
Graylog2 state

requires: requests
"""

__author__ = 'Tomas Neme'
__maintainer__ = 'Tomas Neme'
__email__ = 'lacrymology@gmail.com'


def __virtual__():
    if 'graylog' in __salt__:
        return 'graylog'
    return False


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
    ret = {
        'name': name,
        'changes': {},
        'result': True,
        'comment': "".
    }


    found = False

    inputs = __salt__['graylog.inputs']
    for iput in inputs:
        if iput['message_input']['title'] == title:
            found = iput
        if iput['message_input']['attributes']['port'] == port:
            found = iput

        if found:
            break

    if found:
        ret['comment'] = "Matching Input found: {}".format(found)
        return ret

    params = dict(
        title=title, stype=stype, port=port, creator=creator,
        bind_address=bind_address, buffer_size=buffer_size)

    # not found, create
    if __opts__['test']:
        ret['comment'] = ("graylog.create_gelf_input would have been called "
                          "with the following parameters: {}".format(
                              params))
        return ret

    try:
        res = __salt__['graylog.create_gelf_input'](**params)
    except requests.exceptions.HTTPError, e:
        ret['result'] = False
        ret['changes']['error']: str(e)
        return ret

    ret['changes'] = res
    return ret
