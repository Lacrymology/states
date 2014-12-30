{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Lam Dang Tung <lam@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - build.nrpe
  - nginx.nrpe
  - nrpe
  - pip.nrpe
  - postgresql.server.nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
  - underscore.nrpe
  - uwsgi.nrpe
  - virtualenv.nrpe
  - xml.nrpe
{%- if salt['pillar.get']('openerp:ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('openerp', check_ssl_score=True) }}
