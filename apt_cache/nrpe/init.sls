{%- set formula = 'apt_cache' -%}
{%- from 'nrpe/passive.sls' import passive_check with context %}
include:
  - apt.nrpe
  - nginx.nrpe
  - nrpe
{%- if salt['pillar.get'](formula + ':ssl', False) %}
  - ssl.nrpe
{%- endif %}

{{ passive_check(formula, check_ssl_score=True) }}

{%- if salt['pillar.get'](formula + ':ssl', False) %}
extend:
  check_ssl_configuration.py:
    file:
      - require:
        - file: nsca-{{ formula }}
{%- endif -%}
