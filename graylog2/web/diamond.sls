{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Diamond statistics for Graylog2 Web Interface
-#}
include:
  - diamond
  - rsyslog.diamond
  - mongodb.diamond
  - nginx.diamond
  - uwsgi.diamond

graylog2_web_diamond_resource:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi.graylog2]]
        cmdline = ^graylog2-(worker|master)$
