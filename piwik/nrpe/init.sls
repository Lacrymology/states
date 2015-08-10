{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set ssl = salt['pillar.get']('piwik:ssl', False) %}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - nrpe
  - apt.nrpe
  - mysql.server.nrpe
  - nginx.nrpe
  - php.nrpe
  - uwsgi.nrpe
{%- if ssl %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('piwik', check_ssl_score=True) }}
