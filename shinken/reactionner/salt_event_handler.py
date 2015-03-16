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
#     --host-name $HOSTNAME$

import logging
import json
import subprocess

import pysc

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
        return argp

    def main(self):
        service_state = self.config["service_state"]
        service_state_type = self.config["service_state_type"]
        service_desc = self.config["service_desc"]
        service_display_name = self.config["service_display_name"]
        minion_id = self.config["hostname"]

        if service_state == "CRITICAL" and service_state_type == "HARD":
            payload = json.dumps(
                {"data": {
                    "minion_id": minion_id,
                    "service_desc": service_desc,
                    "service_display_name": service_display_name,
                }})
            tag = "salt-common/alert/" + service_desc
            subprocess.check_call(
                ["/usr/local/bin/salt_fire_event.py",
                 "--payload", payload, "--tag", tag])
            logger.debug(
                "shinken fired event: payload %s, tag %s", "payload", "tag")

if __name__ == '__main__':
    FireEvent().run()
