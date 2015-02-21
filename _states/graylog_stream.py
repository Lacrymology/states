# -*- coding: utf-8 -*-
# Usage of this is governed by a license that can be found in doc/license.rst.

"""
graylog_stream states

.. note:: requires: requests
"""

__author__ = 'Diep Pham'
__maintainer__ = 'Diep Pham'
__email__ = 'favadi@robotinfra.com'

import requests


def __virtual__():
    if 'graylog.streams' not in __salt__:
        return False
    return 'graylog_stream'


def present(
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


def absent(name):
    """
    Delete a stream with given title.

    :param title: Descriptive name of the stream.
    """
    ret = {
        'name': name,
        'changes': {},
        'result': True,
        'comment': "",
    }

    # Check if stream with same title exists
    is_exist = False
    stream_ids = []
    streams = __salt__['graylog.streams']()
    for stream in streams:
        if stream['title'] == name:
            is_exist = True
            stream_ids.append(stream['id'])

    if __opts__['test']:
        if is_exist:
            ret['comment'] = {'stream_id', stream_ids}
        return ret

    try:
        res = __salt__['graylog.delete_stream'](name)
    except requests.exceptions.HTTPError, e:
        ret['result'] = False
        ret['changes']['error'] = str(e)
        return ret

    ret['changes'] = res
    return ret
