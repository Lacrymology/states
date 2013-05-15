{#
 Diamond statistics for Git Server
#}
include:
  - diamond
  - ssh.server.diamond

git_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[git-server]]
        exe = ^\/usr\/bin\/git-shell$
