{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 
 Diamond statistics for Graphite
-#}
include:
  - diamond
  - rsyslog.diamond
  - memcache.diamond
  - nginx.diamond
  - postgresql.server.diamond
  - statsd.diamond
  - uwsgi.diamond

uwsgi_diamond_graphite_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi.graphite]]
        cmdline = ^graphite-(worker|master)$
