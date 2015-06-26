{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check, passive_absent with context %}

include:
  - apt.nrpe
  - bash.nrpe
  - cron.nrpe
  - nrpe
  - rsyslog.nrpe

{%- if salt['pillar.get']('clamav:daily_scan', False) %}
{{ passive_check('clamav') }}
{%- else %}
{{ passive_absent('clamav') }}
{%- endif %}
