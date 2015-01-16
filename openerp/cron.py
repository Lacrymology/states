#!/usr/local/openerp/bin/python
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.
#
# Author: Bruno Clermont <bruno@robotinfra.com>
# Maintainer: Diep Pham <favadi@robotinfra.com>

import logging
import logging.config
import os
import sys
import yaml

full_path = os.path.realpath(__file__)
current_dir = os.path.dirname(full_path) + "/"
sys.path.append(current_dir)

config = yaml.load(open('/usr/local/openerp/config.yaml'))
logging.config.dictConfig(config['logging'])

import openerp

openerp.conf.server_wide_modules = []

conf = openerp.tools.config
conf['addons_path'] = os.path.join(current_dir, 'openerp', 'addons')
conf['static_http_document_root'] = current_dir

conf['db_host'] = config['db']['host']
conf['db_user'] = config['db']['user']
conf['db_port'] = config['db']['port']
conf['db_password'] = config['db']['password']
conf['admin_passwd'] = config['admin']['password']
conf['log_level'] = config['log_level']

from openerp.cli import server
server.check_root_user()
server.check_postgres_user()
server.report_configuration()
server.setup_pid_file()
server.preload_registry(config['company_db'])

openerp.modules.module.initialize_sys_path()
openerp.modules.loading.open_openerp_namespace()

logger = logging.getLogger()
logger.debug("Starting workers")
openerp.service.cron.cron_runner(0)
