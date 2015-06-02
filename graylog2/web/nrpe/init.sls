{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - logrotate.nrpe
  - nginx.nrpe
  - nrpe
  - rsyslog.nrpe
{% if salt['pillar.get']('graylog2:ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('graylog2.web', pillar_prefix='graylog2', check_ssl_score=True) }}
