#!/usr/bin/env python

# Use of this is governed by a license that can be found in doc/license.rst.

"""
# Fire an event to salt master when a service goes in to hard problem state
"""

# Usage:
# /usr/local/shinken/bin/salt_event_handler
#     --service-state $SERVICESTATE$ --service-state-type $SERVICESTATETYPE$ \
#     --service-desc $SERVICEDESC$ \
#     --service-display-name $SERVICEDISPLAYNAME$ \
#     --host-name $HOSTNAME$ --formula $_SERVICEFORMULA$

import json
import logging
import sys

import pysc

sys.path.append('/usr/local/bin')
from salt_fire_event import fire_event

logger = logging.getLogger(__name__)


class FireEvent(pysc.Application):
    def get_argument_parser(self):
        argp = super(FireEvent, self).get_argument_parser()
        argp.add_argument(
            "--service-state", help="service state", required=True)
        argp.add_argument(
            "--service-state-type", help="service state type (HARD or SOFT)",
            required=True)
        argp.add_argument(
            "--service-desc", help="service description", required=True)
        argp.add_argument(
            "--service-display-name", help="service display name",
            required=True)
        argp.add_argument(
            "--hostname", help="hostname of service",
            required=True)
        argp.add_argument(
            "--formula", help="formula of service",
            required=True)
        return argp

    def main(self):
        c = self.config
        if c["service_state"] != "OK" and c["service_state_type"] == "HARD":
            payload = json.dumps(
                {"data": {
                    "minion_id": c["hostname"],
                    "service_desc": c["service_desc"],
                    "service_state": c["service_state"],
                    "service_state_type": c["service_state_type"],
                    "service_display_name": c["service_display_name"],
                    "reaction": c["reaction"],
                }})
            tag = "salt-common/alert/" + c["service_desc"]
            fire_event(payload, tag)

if __name__ == '__main__':
    FireEvent().run()
