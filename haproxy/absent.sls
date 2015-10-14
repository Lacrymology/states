{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

haproxy:
  service:
    - dead
  pkg:
    - purged
    - require:
      - service: haproxy
  user:
    - absent
    - require:
      - pkg: haproxy
  group:
    - absent
    - require:
      - user: haproxy
  file:
    - absent
    - name: /etc/apt/sources.list.d/haproxy.list
