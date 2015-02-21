{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set ssl = salt['pillar.get']('ldap:ssl', False) %}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - nrpe
{%- if ssl %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('openldap') }}
