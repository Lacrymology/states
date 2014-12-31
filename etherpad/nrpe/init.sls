{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Dang Tung Lam <lam@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
{%- set formula = 'etherpad' -%}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - git.nrpe
  - nginx.nrpe
  - nodejs.nrpe
  - nrpe
  - postgresql.server.nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
{%- if salt['pillar.get'](formula + ':ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check(formula, check_ssl_score=True) }}

extend:
  check_psql_encoding.py:
    file:
      - require:
        - file: nsca-{{ formula }}
  /usr/lib/nagios/plugins/check_pgsql_query.py:
    file:
      - require:
        - file: nsca-{{ formula }}
