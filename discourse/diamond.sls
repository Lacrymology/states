{#
 Diamond statistics for Discourse
#}
include:
  - diamond
  - postgresql.server.diamond
  - nginx.diamond
  - redis.diamond
  - uwsgi.diamond

discourse_diamond_resource:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi.discourse]]
        cmdline = ^discourse-(worker|master)$

