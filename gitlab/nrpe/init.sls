{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set formula = 'gitlab' -%}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - gitlab
  - apt.nrpe
  - build.nrpe
  - git.nrpe
  - logrotate.nrpe
  - nginx.nrpe
  - nodejs.nrpe
  - postgresql.server.nrpe
  - python.nrpe
  - redis.nrpe
  - ssh.server.nrpe
  - sudo.nrpe
  - xml.nrpe
{%- if salt['pillar.get']('gitlab:ssl', False) %}
  - ssl.nrpe
{%- endif %}

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
