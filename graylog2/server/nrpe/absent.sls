{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
{{ passive_absent('graylog2.server') }}

/usr/lib/nagios/plugins/check_new_logs.py:
  file:
    - absent

/etc/nagios/nrpe.d/graylog2-server.cfg:
  file:
    - absent

