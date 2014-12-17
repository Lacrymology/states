#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Command line script that builds a pillar (yaml) file from the examples in the
docs.
"""

import sys
import argparse
import collections
import os

import yaml


def update(dest, upd):
    """
    Deep-merge function for dictionaries. Taken verbatim from
    salt.utils.dictupdate
    """
    for key, val in upd.iteritems():
        if isinstance(val, collections.Mapping):
            ret = update(dest.get(key, {}), val)
            dest[key] = ret
        else:
            dest[key] = upd[key]
    return dest


def main(doc_path, modules_path, output):
    """
    Merge pillars and dump them into a file

    :param doc_path: The output directory of sphinx
    :param modules_path: the path to the _modules directory of salt-common
    :param output: the output file
    """
    sys.path.append(modules_path)
    import qa

    docs = qa.parse_doctrees(doc_path)
    pillar = {}

    for details in docs.itervalues():
        if 'examples' in details.get('mandatory', {}):
            for example in details['mandatory']['examples']:
                pillar = update(pillar, example)

    with open(output, 'w') as out:
        yaml.dump(pillar, out, default_flow_style=False, default_style='|')


if __name__ == '__main__':
    argp = argparse.ArgumentParser()
    argp.add_argument(
        "--doc-path", '-d',
        default=os.path.join(__file__, '..', '..', '..', 'salt-doc'),
        help="Sphinx's output path")
    argp.add_argument(
        "--modules-path", '-m',
        default=os.path.join(__file__, '..', '..', '_modules'),
        help="The path to <salt-common>/_modules")
    argp.add_argument("--output", '-o', required=True,
                      help="The output file")
    args = argp.parse_args()
    main(args.doc_path, args.modules_path, args.output)
