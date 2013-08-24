{#
 Diamond statistics for GitLab
#}
include:
  - diamond
  - postgresql.server.diamond
  - nginx.diamond
  - redis.diamond
  - uwsgi.diamond

gitlab_diamond_resource:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[uwsgi.gitlab]]
        cmdline = ^gitlab-(worker|master)$
