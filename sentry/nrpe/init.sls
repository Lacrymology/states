{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set formula = 'sentry' -%}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - bash
  - cron
  - sentry
  - web
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

{%- set dsn_file = "/var/lib/deployments/sentry/monitoring_dsn" %}
sentry_monitoring:
  cmd:
    - script
    - source: salt://sentry/nrpe/sentry_monitoring.py
    - args: >
        --password {{ salt["password.generate"]("sentry_monitoring") }}
        --dsn-file {{ dsn_file }}
{%- if salt['pillar.get']("__test__", False) %}
        --test
{%- endif %}
    - unless: test -f {{ dsn_file }}
    - user: www-data
    - require:
      - file: /var/lib/deployments/sentry
      - file: sentry-uwsgi
      - module: pysc
      - service: sentry
      - user: web

/etc/cron.hourly/sentry-monitoring:
  file:
    - managed
    - user: root
    - group: root
    - mode: 500
    - template: jinja
    - source: salt://sentry/nrpe/cron_hourly.jinja2
    - context:
        dsn_file: {{ dsn_file }}
    - require:
      - cmd: sentry_monitoring
      - module: raven
      - pkg: cron
