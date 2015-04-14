# -*- coding: utf-8 -*-
# copy from
# https://github.com/saltstack/salt/blob/43e69d2842c34cfb49b8997c7c3d5b378b43406a/salt/utils/yamlencoding.py

# Import Python libs
from __future__ import absolute_import
import io
import sys

# Import 3rd-party libs
import yaml

# Useful for very coarse version differentiation.
PY2 = sys.version_info[0] == 2
PY3 = sys.version_info[0] == 3

if PY3:
    text_type = str
else:
    text_type = unicode


def yaml_dquote(text):
    '''
    Make text into a double-quoted YAML string with correct escaping
    for special characters.  Includes the opening and closing double
    quote characters.
    '''
    with io.StringIO() as ostream:
        yemitter = yaml.emitter.Emitter(ostream)
        yemitter.write_double_quoted(text_type(text))
        return ostream.getvalue()


def yaml_squote(text):
    '''
    Make text into a single-quoted YAML string with correct escaping
    for special characters.  Includes the opening and closing single
    quote characters.
    '''
    with io.StringIO() as ostream:
        yemitter = yaml.emitter.Emitter(ostream)
        yemitter.write_single_quoted(text_type(text))
        return ostream.getvalue()


def yaml_encode(data):
    '''
    A simple YAML encode that can take a single-element datatype and return
    a string representation.
    '''
    yrepr = yaml.representer.SafeRepresenter()
    ynode = yrepr.represent_data(data)
    if not isinstance(ynode, yaml.ScalarNode):
        raise TypeError(
            "yaml_encode() only works with YAML scalar data;"
            " failed for {0}".format(type(data))
        )

    tag = ynode.tag.rsplit(':', 1)[-1]
    ret = ynode.value

    if tag == "str":
        ret = yaml_dquote(ynode.value)

    return ret
