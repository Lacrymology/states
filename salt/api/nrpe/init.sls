{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context -%}
{%- set ssl = salt['pillar.get']('salt_api:ssl', False) -%}
include:
  - apt.nrpe
  - git.nrpe
  - nginx.nrpe
  - nrpe
  - pip.nrpe
  - rsyslog.nrpe
  - salt.master.nrpe
{%- if ssl %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('salt.api', pillar_prefix='salt_api', check_ssl_score=True) }}
