#!/usr/bin/env python2
# -*- coding: utf-8 -*-

import argparse
import os
import requests

emoticons = {
    'CRITICAL': ':skull:',
    'WARNING': ':warning:',
    'DOWN': ':boom:',
}
HOST_FMT = (
    "Host [{host_alias} "
    "({host_address})]({shinken_url}/host/{host_name}) "
    "is **{host_state}** at {long_date_time}.\nDetail: {host_output}"
)
SERVICE_FMT = ('**{service_desc}** is **{service_state}** at '
               '{long_date_time} on [{host_alias} '
               '({host_address})]({shinken_url}/host/{host_name})\n'
               'Additional info: {service_output}\n'
               '*Services*:   `{total_service_ok}` :ok:'
               '  `{total_service_warning}` :warning:'
               '  `{total_service_critical}` :x:'
               '  `{total_service_unknown}` :question:'
               '  `{total_service_problem}` :interrobang:'
               )


if __name__ == "__main__":
    argp = argparse.ArgumentParser()
    for arg in ('mode',
                'config',
                'service-desc', 'service-state', 'long-date-time',
                'host-alias', 'host-address',
                'shinken-url', 'host-name',
                'host-output', 'host-state',
                'service-output', 'total-service-ok',
                'total-service-warning',
                'total-service-critical', 'total-service-unknown',
                'total-service-problem'):
        argp.add_argument('--' + arg, default='N/A')

    args = argp.parse_args()

    if args.mode == 'host':
        message = HOST_FMT.format(
            host_alias=args.host_alias,
            host_address=args.host_address,
            shinken_url=args.shinken_url,
            host_name=args.host_name,
            host_state=args.host_state,
            long_date_time=args.long_date_time,
            host_output=args.host_output
        )
        state = args.host_state
    else:
        message = SERVICE_FMT.format(
            service_desc=args.service_desc,
            service_state=args.service_state,
            long_date_time=args.long_date_time,
            host_alias=args.host_alias,
            host_address=args.host_address,
            shinken_url=args.shinken_url,
            host_name=args.host_name,
            service_output=args.service_output,
            total_service_ok=args.total_service_ok,
            total_service_warning=args.total_service_warning,
            total_service_critical=args.total_service_critical,
            total_service_unknown=args.total_service_unknown,
            total_service_problem=args.total_service_problem
            )
        state = args.service_state

    emo = emoticons.get(state, ':loudspeaker:')
    message = {'text': emo + message,
               'icon_url': "{0}/static/img/logo.png".format(args.shinken_url)
               }
    hook_url = os.environ.get('MM_HOOK_URL', None)
    if not hook_url:
        hook_url = open(args.config).read().strip()
    print requests.post(hook_url, json=message)
