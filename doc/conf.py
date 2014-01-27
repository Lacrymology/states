# {{ pillar['message_do_not_modify'] }}
# -*- coding: utf-8 -*-

import sys, os
import sphinx_rtd_theme


extensions = []
templates_path = ''
source_suffix = '.rst'
master_doc = 'doc/index'
project = u'Salt common'
copyright = u'BFS'
version = '2014.1'
release = 'dev'
pygments_style = 'sphinx'
html_theme = 'sphinx_rtd_theme'
html_theme_path = [sphinx_rtd_theme.get_html_theme_path()]
#html_title = {{ salt['pillar.get']('sphinx:html_title') }}
html_static_path = ['']
html_show_copyright = True
htmlhelp_basename = ''
