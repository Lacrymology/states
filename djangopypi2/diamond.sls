{#
 Diamond statistics for djangopypi2
#}
include:
  - diamond
  - rsyslog.diamond
  - memcache.diamond
  - nginx.diamond
  - postgresql.server.diamond
  - statsd.diamond
  - uwsgi.diamond

uwsgi_diamond_djangopypi2_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi.djangopypi2]]
        cmdline = ^djangopypi2-(worker|master)$
