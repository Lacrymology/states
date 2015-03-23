{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - graylog2.server.absent
  - graylog2.web.absent

{%- for file in ['/var/run/graylog2', '/var/lib/graylog2'] %}
{{ file }}:
  file:
    - absent
    - require:
      - service: graylog2-server
      - service: graylog2-web
{%- endfor -%}

{%- set version = '1.0' %}
graylog:
  pkgrepo:
    - absent
    - name: deb https://packages.graylog2.org/repo/debian/ {{ grains['lsb_distrib_codename'] }} {{ version }}
