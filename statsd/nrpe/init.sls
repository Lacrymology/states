{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - nrpe
  - python.dev.nrpe
  - rsyslog.nrpe
  - virtualenv.nrpe

{{ passive_check('statsd') }}
