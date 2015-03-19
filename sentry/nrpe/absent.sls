{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('sentry') }}

/etc/nagios/nrpe.d/sentry-nginx.cfg:
  file:
    - absent

/etc/nagios/nrpe.d/postgresql-sentry.cfg:
  file:
    - absent

/usr/lib/nagios/plugins/check_sentry_events.py:
  file:
    - absent
