{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - diamond
  - haproxy

haproxy_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[haproxy]]
        cmdline = ^\/usr\/sbin\/haproxy -f \/etc\/haproxy\/haproxy.cfg -D -p \/var\/run\/haproxy.pid$

extend:
  diamond:
    service:
      - require:
        - service: haproxy
