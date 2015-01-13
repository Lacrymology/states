{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- set formula = 'gitlab' -%}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - gitlab
  - apt.nrpe
  - build.nrpe
  - git.nrpe
  - logrotate.nrpe
  - nginx.nrpe
  - postgresql.server.nrpe
  - python.nrpe
  - redis.nrpe
  - rsyslog.nrpe
  - ssh.server.nrpe
{%- if salt['pillar.get']('gitlab:ssl', False) %}
  - ssl.nrpe
{%- endif %}
  - uwsgi.nrpe
  - xml.nrpe

{{ passive_check('gitlab', check_ssl_score=True) }}

extend:
  check_psql_encoding.py:
    file:
      - require:
        - file: nsca-{{ formula }}
        - postgres_database: gitlab
  /usr/lib/nagios/plugins/check_pgsql_query.py:
    file:
      - require:
        - file: nsca-{{ formula }}
        - postgres_database: gitlab
