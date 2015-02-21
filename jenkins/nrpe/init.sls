{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - cron.nrpe
  - nginx.nrpe
  - pysc.nrpe
  - ssh.client.nrpe
{%- if salt['pillar.get']('jenkins:job_cleaner', False) %}
  - requests.nrpe
{%- endif %}
{% if salt['pillar.get']('jenkins:ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('jenkins', check_ssl_score=True) }}
