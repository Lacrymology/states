{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - diamond
  - pppd.diamond
  - xl2tpd

xl2tpd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require:
      - service: xl2tpd
    - text:
      - |
        [[xl2tpd]]
        cmdline = ^\/usr\/sbin\/xl2tpd
