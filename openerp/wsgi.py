#!/usr/local/openerp/bin/python
# -*- coding: utf-8 -*-

#Copyright (c) 2013, Lam Dang Tung
#All rights reserved.
#
#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:
#
#1. Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#2. Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
#ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#Author: Lam Dang Tung <lamdt@familug.org>
#Maintainer: Lam Dang Tung <lamdt@familug.org>

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
