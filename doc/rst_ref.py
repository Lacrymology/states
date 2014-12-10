#!/usr/bin/env python

import copy
import logging
import os
import re
import sys


from build import common_root_dir

logger = logging.getLogger(__name__)


def insert_ref(filename, char):
    logger.debug("Look %s", filename)
    prefix = os.path.splitext(os.path.basename(filename))[0]
    with open(filename) as fh:
        original_content = fh.read()
    ret = re.findall(r"^(.*)\n(.*)\n(.+)(\n^%s+)$" % char,
                                               original_content, re.MULTILINE)

    # print content
    if ret:
        content = copy.copy(original_content)
        for match in ret:
            prev_line, empty_line, header, markup = match
            ref = '.. _%s-%s:' % (prefix,
                                  header.replace(
                                      ':', '-').replace(
                                      '{{ ', '').replace(
                                      ' }}', '').replace(
                                      ' ', ''))
            if empty_line or prev_line != ref:

                content = content.replace(
                    header + markup,
                    os.linesep.join((ref, '', header + markup)))

        if content != original_content:
            with open(filename, 'w') as fh:
                fh.write(content)


def main():
    logging.basicConfig(level=logging.DEBUG, stream=sys.stdout)
    for dirpath, dirnames, filenames in os.walk(common_root_dir()):
        for char, doc_files in (
                ('-', ('metrics.rst',)),
                ('~', ('monitor.rst', 'pillar.rst'))
            ):
            for doc_file in doc_files:
                if doc_file in filenames:
                    insert_ref(os.path.join(dirpath, doc_file), char)


if __name__ == '__main__':
    main()
