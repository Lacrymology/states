{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set formula = 'doc.publish' %}
{%- set ssl = salt['pillar.get']('doc:ssl', False) %}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - cron.nrpe
  - nginx.nrpe
  - python.nrpe
  - pysc.nrpe
{%- if ssl %}
  - ssl.nrpe
{%- endif %}

{{ passive_check("doc.publish", pillar_prefix="doc", check_ssl_score=True) }}
