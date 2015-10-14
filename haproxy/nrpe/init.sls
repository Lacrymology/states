{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
{%- from 'haproxy/check_ssl.jinja2' import ssl_certs with context %}

include:
  - apt.nrpe
  - nrpe
{%- if ssl_certs %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('haproxy') }}
