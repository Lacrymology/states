{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set formula = 'sentry' -%}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - bash.nrpe
  - cron.nrpe
  - memcache.nrpe
  - nginx.nrpe
  - nrpe
  - pip.nrpe
  - postgresql.server.nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
{% if salt['pillar.get']('graphite_address', False) %}
  - statsd.nrpe
{% endif %}
  - redis.nrpe
  - sudo.nrpe
  - uwsgi.nrpe
  - virtualenv.nrpe
{%- if salt['pillar.get'](formula + ':ssl', False) %}
  - ssl.nrpe
{%- endif %}
  - xml.nrpe

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
