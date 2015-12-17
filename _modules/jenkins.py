# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.

'''
Get latest build number of given Jenkins jobs
'''

__author__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__maintainer__ = 'Viet Hung Nguyen <hvn@robotinfra.com>'
__email__ = 'hvn@robotinfra.com'

import logging
import requests

logger = logging.getLogger(__name__)


def latest_build(jenkins_addr, jobname, username, token):
    '''
    Access API of given jobname at jenkins_addr
    and find out latest build number
    '''
    request_url = '{0}/job/{1}/api/json'.format(jenkins_addr.rstrip('/'),
                                                jobname)
    build_number = None
    try:
        r = requests.get(request_url, auth=(username, token))
        build_number = r.json()['lastStableBuild'].get('number', None)
    except Exception as e:
        logger.error(e, exc_info=True)
    return build_number
