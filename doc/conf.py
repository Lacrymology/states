# {{ salt['pillar.get']('message_do_not_modify') }}
# -*- coding: utf-8 -*-

# Use of this source code is governed by a BSD license that can be
# found in the doc/license.rst file.
#
# Author: Viet Hung Nguyen <hvn@robotinfra.com>
# Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

import datetime

import sphinx_rtd_theme

extensions = ['sphinx.ext.todo',
              'sphinx.ext.autodoc',
              'sphinx.ext.intersphinx',
              'sphinx.ext.extlinks']
todo_include_todos = True
autodoc_default_flags = ['members', 'undoc-members']
intersphinx_mapping = {
    'salt': ('http://docs.saltstack.com/', None),
    'raven': ('http://raven.readthedocs.org/',
              'http://raven.readthedocs.org/en/latest/objects.inv'),
}
extlinks = {
    'salt': ('http://docs.saltstack.com/en/latest%s.html', ''),
    'raven': ('http://raven.readthedocs.org/en/latest%s.html', 'raven'),
}

templates_path = ''
source_suffix = '.rst'
master_doc = 'doc/index'
project = u'RobotInfra'
copyright = project
version = str(datetime.datetime.now())
release = 'dev'
pygments_style = 'sphinx'
html_theme = 'sphinx_rtd_theme'
html_theme_path = [sphinx_rtd_theme.get_html_theme_path()]
html_static_path = ['']
html_show_copyright = True
htmlhelp_basename = ''

import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
