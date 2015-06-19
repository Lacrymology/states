{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
{%- from 'nrpe/passive.jinja2' import passive_absent with context %}
include:
  - apt.nrpe
  - bash.nrpe
  - cron.nrpe
  - nrpe
  - rsyslog.nrpe

{{ passive_check('clamav.server') }}
{{ passive_absent('clamav') }}
