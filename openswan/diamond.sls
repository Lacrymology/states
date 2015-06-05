{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - diamond
  - openswan

openswan_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require:
      - service: openswan
    - text:
      - |
        [[openswan]]
        cmdline = ^\/bin\/sh \/usr\/lib\/ipsec\/_plutorun
