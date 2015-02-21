{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - dovecot
  - nrpe
  - rsyslog.nrpe
  - postfix.nrpe
{%- if salt['pillar.get']('dovecot:ssl', False)  %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('dovecot') }}
