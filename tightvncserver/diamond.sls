{#
 Diamond statistics for tightvncserver
#}

include:
  - apt.diamond
  - diamond

tightvncserver_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[tightvncserver]]
        name = ^tightvncserver$
