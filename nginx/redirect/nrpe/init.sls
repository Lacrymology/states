{%- from 'nrpe/passive.jinja2' import passive_check with context %}

include:
  - nginx.nrpe
{%- if salt['pillar.get']('redirect:ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check('nginx.redirect') }}
