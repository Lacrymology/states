{#
 Diamond statistics for Sentry
#}
include:
  - diamond
  - rsyslog.diamond
  - memcache.diamond
  - nginx.diamond
  - postgresql.server.diamond
  - statsd
  - uwsgi.diamond

uwsgi_diamond_sentry_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi.sentry]]
        cmdline = ^sentry-(worker|master)$
