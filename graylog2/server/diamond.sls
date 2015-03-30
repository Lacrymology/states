{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - diamond
  - mongodb.diamond
  - rsyslog.diamond
{%- if salt['pillar.get']("__test__", False) %}
  - elasticsearch.diamond
{%- endif %}

graylog2_server_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[graylog2]]
        cmdline = java.+\/usr\/share\/graylog-server\/graylog\.jar
