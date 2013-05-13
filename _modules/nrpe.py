# -*- coding: utf-8 -*-

'''
Perform a NRPE check
'''

import logging
import re

logger = logging.getLogger(__name__)

__NRPE_RE = re.compile('^command\[([^\]]+)\]=(.+)$')

def _check_list(config_dir='/etc/nagios/nrpe.d'):
    '''
    List all available NRPE check
    :param config_dir: path where config files are
    :return: dict of command name and their command line
    '''
    output = {}
    for filename in __salt__['file.find'](config_dir, type="f"):
        with open(filename, 'r') as input_fh:
            for line in input_fh:
                match = __NRPE_RE.match(line)
                if match:
                    output[match.group(1)] = match.group(2)
    return output

def run_check(check_name):
    '''
    Run a specific nagios check

    CLI Example::

        salt '*' nrpe.run_check <check name>

    '''
    checks = _check_list()
    logger.debug("Found %d checks", len(checks.keys()))
    ret = {
        'name': 'run_check',
        'changes': {},
    }

    if check_name not in checks:
        ret['result'] = False
        ret['comment'] = "Can't find check '{0}'".format(check_name)
        return ret

    output = __salt__['cmd.run_all'](checks[check_name], runas='nagios')
    logger.debug("cmd.run_all output: %s", output)
    ret['content'] = "stdout: '{stdout}' stderr: '{stderr}'".format(output)
    ret['result'] = output['retcode'] == 0
    return ret
