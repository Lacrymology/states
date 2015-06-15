{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - build.nrpe
  - logrotate.nrpe
  - mysql.nrpe
  - mysql.server.nrpe
  - nginx.nrpe
  - nrpe
  - php.nrpe
{%- if salt['pillar.get']('wordpress:ssl', False) %}
  - ssl.nrpe
{%- endif %}
  - uwsgi.nrpe

{{ passive_check('wordpress', check_ssl_score=True) }}
