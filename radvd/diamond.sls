{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - diamond
  - radvd

radvd_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[radvd]]
        cmdline = ^\/usr\/sbin\/radvd -u radvd -p \/var\/run\/radvd\/radvd.pid$

extend:
  diamond:
    service:
      - require:
        - service: radvd
