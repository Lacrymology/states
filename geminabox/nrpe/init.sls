{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set formula = "geminabox" %}
{%- set ssl = salt['pillar.get']('geminabox:ssl', False) %}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - nginx.nrpe
  - uwsgi.nrpe
{%- if ssl %}
  - ssl.nrpe
{%- endif %}

{{ passive_check(formula, check_ssl_score=True) }}
