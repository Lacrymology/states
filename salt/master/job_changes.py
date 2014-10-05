# -*- coding: utf-8 -*-

"""
Parse output of salt-run jobs.lookup_jid (or similar).
Print only changes or failures.
Skip non-changes combined with success.

To run just salt-run jobs.lookup_jid | job_changes.py
or salt-run jobs.lookup_jid > /path/to/out
and pipe this file to job_changes.py
"""

import logging
import os
import sys
import re

logger = logging.getLogger(__name__)
logger.addHandler(logging.NullHandler())


class StateResult(object):
    """
    A single state output
    """
    def __init__(self, minion, state=None, name=None, function=None,
                 result=None, comment='', changes=''):
        self.minion = minion
        self.name = name
        self.function = function
        self.comment = comment
        self.changes = changes
        self._state = None
        if state:
            self.state = state
        self._result = None
        if result:
            self.result = result

    def __repr__(self):
        keys = ('minion', 'name', 'function', 'comment', 'changes', 'state',
                'result')
        output = {}
        for key in keys:
            output[key] = getattr(self, key)
        return repr(output)

    @property
    def result(self):
        return self._result

    @result.setter
    def result(self, value):
        if type(value) is bool:
            self._result = value
        elif isinstance(value, basestring):
            self._result = bool(value)
        else:
            raise ValueError(value)

    @property
    def state(self):
        return self._state

    @state.setter
    def state(self, value):
        prefix = '- '
        if value.startswith(prefix):
            logger.debug("Set state, remove '%s' from begining of '%s'",
                         prefix, value)
            self._state = value[len(prefix):]
        else:
            self._state = value

    def process(self):
        changes = self.changes.lstrip().rstrip()
        if not self.name or not self.state or not self.function \
           or not self.result or not self.result or not self.comment \
           or not self.changes:
            logger.warning("Incompleted: %s", self)
        elif (self.result and changes) or not self.result:
            if self.result:
                result = "SUCCESS"
            else:
                result = "FAILURE"
            print '*' * 10
            print '[%s] %s %s.%s: %s "%s": %s' % (
                self.minion, self.name, self.state,
                self.function, result, self.comment, self.changes)


def process(state_result):
    """
    Wrapper around :func:`Block.process` to handle uninitialized instance.
    """
    try:
        func = state_result.process
    except AttributeError:
        pass
    else:
        func()
    state_result = None


def parse(iter_input):
    """
    Go trough multiple lines of strings and parse to outline changes and
    failures.
    """
    line_number = 0
    line_re = re.compile(r'^\s+([^:]+):\s+(.+)$')
    minion_re = re.compile(r'^[a-zA-Z0-9\-_\.]+:$')
    state_result = None
    # go trough all lines and handle all possible cases
    for line in iter_input:
        line_number += 1
        line = line.rstrip(os.linesep)

        if line.startswith('----------'):
            process(state_result)
            continue
        if not line or line.startswith('Succeeded') or \
           line.startswith('Failed') or line.startswith('Total'):
            continue
        if line.startswith('Summary'):
            logger.debug("Reached end of minion at %d.", line_number)
            process(state_result)
            continue
        if minion_re.match(line):
            state_result = StateResult(line.rstrip(':'))
            logger.debug("New minion: %s", line)
            continue
        if not line.startswith(' ') and not state_result:
            logger.error("Invalid line '%s'", line)
            continue
        match = line_re.match(line)
        if match:
            key, value = match.groups()
            setattr(state_result, key.lower(), value)
        else:
            if state_result.changes:
                state_result.changes += os.linesep + line
            else:
                state_result.changes += line


def main():
    logging.basicConfig(level=logging.ERROR, stream=sys.stderr)
    parse(sys.stdin)

if __name__ == '__main__':
    main()
