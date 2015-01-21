#!/usr/bin/env python2
# -*- coding: utf-8 -*-
import argparse
import datetime
import sys

'''
Find most time-consuming tasks: (column 1 is calculated gaps between 2
consecutive steps)
$ python findgap.py develop-stdout.log -v -l 100 | sort -k1,1 -n

Expected log format in input file:
2015-01-18 17:20:58,646 salt.loader (loader.gen_functions:846) Loaded virtualenv_mod as virtual virtualenv
'''

__author__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__maintainer__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__email__ = 'hvn@robotinfra.com'


def main():
    argp = argparse.ArgumentParser()
    argp.add_argument('LOGFILE')
    argp.add_argument('--verbose', '-v', action='store_true')
    argp.add_argument('--print-name', '-p', action='store_true',
                      help='print to stdout the test testname where time '
                           'consuming step happened')
    argp.add_argument('--larger-equal', '-l', metavar='N seconds',
                      help='only print out the step which took >= N seconds',
                      type=int,
                      default=20)

    args = argp.parse_args()

    prior_line = testname = ''
    if args.LOGFILE:
        infile = open(args.LOGFILE)
    else:
        infile = sys.stdin

    for i, line in enumerate(infile):
        line = line.strip()
        if 'Run states:' in line and '.absent' not in line:
            testname = line
        try:
            timestr = line.split(',')[0]
            timeobj = datetime.datetime.strptime(timestr, '%Y-%m-%d %H:%M:%S')
        except Exception:
            continue

        if i == 0:
            prior_tobj = timeobj

        # two steps which only different in milliseconds,
        # skip but save prior line. This is optimization to avoid
        # calculating gap when it is insignificant.
        # Even it just saves 1 milliseconds for each, when input
        # is 10 million lines, that help save much time.
        if prior_tobj == timeobj:
            prior_line = line
            continue

        gap, prior_tobj = (timeobj - prior_tobj).total_seconds(), timeobj
        if args.larger_equal > gap:
            prior_line = line
            continue

        # when timezone changed, this tool will be fooled, ignore that case
        if "{'timezone':" in line:
            continue

        # gap position must be consistent, output must on 1 line to be able to
        # feed output to other UNIX tools - e.g sort -k1,1
        def _print_output(msg, print_name, testname):
            if print_name:
                print testname
            print msg

        if args.verbose:
            output = '{0} seconds FROM {1} ---> {2}'.format(gap,
                                                            prior_line, line)
            _print_output(output, args.print_name, testname)
        else:
            output = '{0} {1}'.format(gap, timestr)
            _print_output(output, args.print_name, testname)

        prior_line = line

if __name__ == "__main__":
    main()
