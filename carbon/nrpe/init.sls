{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - cron.nrpe
  - pysc.nrpe
  - graphite.common.nrpe
  - nrpe
  - logrotate.nrpe
  - pip.nrpe
  - python.dev.nrpe

{{ passive_check('carbon') }}
