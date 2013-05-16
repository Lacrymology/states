{#
 Diamond statistics for Graphite
#}
include:
  - diamond
  - postgresql.server.diamond
  - uwsgi.diamond
  - nginx.diamond
  - memcache.diamond
  - statsd.diamond
  - gsyslog.diamond

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
