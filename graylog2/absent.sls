{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - graylog2.server.absent
  - graylog2.web.absent

{%- for file in ['/var/run/graylog', '/var/lib/graylog'] %}
{{ file }}:
  file:
    - absent
    - require:
      - service: graylog-server
      - service: graylog-web
{%- endfor %}

graylog:
  pkgrepo:
    - absent
    - name: deb https://packages.graylog2.org/repo/debian/ {{ grains['lsb_distrib_codename'] }} 1.0
  file:
    - absent
    - name: /etc/apt/sources.list.d/graylog.list
    - require:
      - pkgrepo: graylog
