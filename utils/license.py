#!/usr/bin/env python2
'''
Remove license from a file and adding new license.
Used for internal only.

Version: 0.1
'''
import logging
import os
import sys


LICENSE_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                            'license.txt')

logger = logging.getLogger(__name__)
logger.addHandler(logging.StreamHandler(sys.stdout))
logger.setLevel(logging.DEBUG)


def remove_license(lines):
    has_license = False
    has_author = False
    print_out = True
    ret = []
    for l in lines:
        if 'Copyright' in l:
            print_out = False
            has_license = True
        elif 'Author:' in l:
            print_out = True
            has_author = True
        elif '#}' in l:
            print_out = True

        if print_out:
            ret.append(l)

    if not has_author:
        logger.warning('Missing author')
    if not has_license:
        logger.warning('Missing license')

    if has_license:
        logger.info('Removed license')
    return ret


def write_result_to_file(fn, lines):
    with open(fn, 'w') as f:
        for l in lines:
            f.write(l)


def add_new_license(lines, license, force=False):
    if isinstance(license, list):
        license = ''.join(license)

    if not license.endswith('\n'):
        license = '{0}\n'.format(license)

    def _is_licensed(lines):
        open_comment = False
        is_licensed = False
        for l in lines:
            if '{#' in l:
                open_comment = True
            if 'copyright' in l.lower():
                is_licensed = True
            if '#}' in l and '{#' not in l:
                break

        logger.info('is licensed? {0}'.format(is_licensed))

        return (open_comment and is_licensed)

    new_lines = list(lines)
    if not _is_licensed(lines) or force:
        for i, l in enumerate(lines):
            if '{#' in l:
                new_lines.insert(i + 1, '\n')
                new_lines.insert(i + 1, license)
                logger.info('Added new license')
                break
    return new_lines


if __name__ == "__main__":
    try:
        file_to_change = sys.argv[1]
    except IndexError:
        sys.exit('Usage: {0} sls_or_jinja2_file'.format(sys.argv[0]))

    logger.info('Processing {0}...'.format(file_to_change))
    try:
        with open(LICENSE_PATH, 'r') as f:
            license = f.readlines()
    except IOError:
        sys.exit('Please put your license into {0}\n'
                 'And make sure this script can read '
                 'that file'.format(LICENSE_PATH))

    with open(file_to_change, 'r') as f:
        lines = f.readlines()
        removed = remove_license(lines)
        changed = add_new_license(removed, license, force=True)
        write_result_to_file(file_to_change, changed)
