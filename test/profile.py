# -*- coding: utf-8 -*-

"""
Take standard output of integration.py and report slowest executed lines.
"""

import datetime
import logging
import os
import re
import sys
import UserDict

logger = logging.getLogger(__name__)


class Slow(UserDict.IterableUserDict):
    """
    Dict that hold a max_length number of slowest executed operations.
    """

    def __init__(self, max_length, *args, **kwargs):
        self.max_length = max_length
        UserDict.IterableUserDict.__init__(self, *args, **kwargs)

    def fastest(self):
        """
        return fastest executed message.
        """
        keys = self.keys()
        keys.sort()
        return keys[0]

    def append(self, timedelta, message):
        """
        Append a single message to a list of other that took the same time to
        execute.
        """
        try:
            timedelta_list = self[timedelta]
        except KeyError:
            self[timedelta] = []
            timedelta_list = self[timedelta]
        timedelta_list.append(message)

    def free_over(self):
        """
        Remove all faster executed logs over max_length size.
        """
        actual_size = len(self)
        if actual_size > self.max_length:
            logger.debug("%d is over maximum %d, remove keys",
                         actual_size, self.max_length)
            for i in range(0, actual_size - self.max_length):
                fastest = self.fastest()
                logger.debug("Remove fast key %f", fastest)
                del self[fastest]
        else:
            logger.debug("%d size is within than %d limit, skip.",
                         actual_size, self.max_length)

    def process_slow_message(self, timedelta, message):
        """
        Append a message to a list of execution that took the same timedelta.
        If it don't exceed max_length size.
        """
        if len(self) < self.max_length:
            logger.debug("%f is too little, add directly", self.max_length)
            self.append(timedelta, message)
        elif timedelta < self.fastest():
            logger.debug("Ignore %f: already too fast", timedelta)
        else:
            self.append(timedelta, message)
            self.free_over()

    def __str__(self):
        keys = self.keys()
        keys.sort()
        output = ''
        for key in keys:
            for line in self[key]:
                output += '%f: %s' % (key, line)
                output += os.linesep
        return output


def parse(stream, maximum=100):
    """
    return the slowest execution of maximum length
    """
    output = Slow(maximum)
    line_re = re.compile(
        r'^(\d{4})\-(\d\d)\-(\d\d) (\d\d):(\d\d):(\d\d),(\d{3}) (.+)$')
    previous_ts = None
    for line in stream:
        line = line.rstrip(os.linesep)
        match = line_re.match(line)
        if match:
            year, month, day, hour, minute, second, milli, message = \
                match.groups()
            time = datetime.datetime(int(year), int(month), int(day), int(hour),
                                     int(minute), int(second), int(milli))
            if previous_ts:
                elapse = (time - previous_ts).total_seconds()
                output.process_slow_message(elapse, message)
            previous_ts = time
        else:
            logger.debug("Ignore line: %s", line)
    return output


def main():
    logging.basicConfig(level=logging.DEBUG, stream=sys.stdout)
    print parse(sys.stdin)

if __name__ == '__main__':
    main()
