{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
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
        cmdline = ^java.+\-jar \/usr\/local\/graylog2\-server\-.+\/graylog2-server.jar
