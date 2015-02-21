#!/usr/local/openerp/bin/python
# -*- coding: utf-8 -*-
# Use of this is governed by a license that can be found in doc/license.rst.


import os
import sys

import yaml

full_path = os.path.realpath(__file__)
current_dir = os.path.dirname(full_path) + "/"
sys.path.append(current_dir)

config = yaml.load(open('/usr/local/openerp/config.yaml'))

import openerp

openerp.conf.server_wide_modules = ['web']
openerp.service.wsgi_server

conf = openerp.tools.config
conf['addons_path'] = os.path.join(current_dir, 'openerp', 'addons')
conf['static_http_document_root'] = current_dir

conf['db_host'] = config['db']['host']
conf['db_user'] = config['db']['user']
conf['db_port'] = config['db']['port']
conf['db_password'] = config['db']['password']
conf['admin_passwd'] = config['admin']['password']
conf['log_level'] = config['log_level']

application = openerp.service.wsgi_server.application
