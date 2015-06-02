{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'nrpe/passive.jinja2' import passive_check with context %}
{%- from "os.jinja2" import os with context %}
{%- if os.is_precise %}
include:
  - apt.nrpe
  - denyhosts
  - nrpe
  - pysc.nrpe
  - rsyslog.nrpe

{{ passive_check('denyhosts') }}
{%- endif %} {# os.is_precise #}
