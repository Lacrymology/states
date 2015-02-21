{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - apt.nrpe

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
{{ passive_check('xinetd') }}
