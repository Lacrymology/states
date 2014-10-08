{%- from 'nrpe/passive.sls' import passive_check with context %}
include:
  - apt.nrpe
  - nginx.nrpe
  - nrpe
{%- if salt['pillar.get']('apt_cache:ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('apt_cache', check_ssl_score=True) }}
