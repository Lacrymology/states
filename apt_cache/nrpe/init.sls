{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Quan Tong Anh <quanta@robotinfra.com>
-#}
{%- set formula = 'apt_cache' -%}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}
include:
  - apt.nrpe
  - nginx.nrpe
  - nrpe
{%- set ssl =  salt['pillar.get'](formula + ':ssl', False) %}
{%- if ssl %}
  - ssl.nrpe
{%- endif %}

{{ passive_check(formula, check_ssl_score=True) }}

{%- if ssl %}
extend:
  check_ssl_configuration.py:
    file:
      - require:
        - file: nsca-{{ formula }}
{%- endif -%}
