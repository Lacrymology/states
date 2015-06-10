{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
{%- if salt['pillar.get']('postfix:spam_filter', False) %}
  - amavis.nrpe
    {%- if salt['pillar.get']('amavis:check_virus', True) %}
  - clamav.server.nrpe
    {%- endif %}
{%- endif %}
  - apt.nrpe
  - nrpe
{% if salt['pillar.get']('postfix:ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('postfix') }}
