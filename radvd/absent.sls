{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

radvd:
  service:
    - dead
  pkg:
    - purged
    - require:
      - service: radvd
  user:
    - absent
    - require:
      - pkg: radvd
  group:
    - absent
    - require:
      - user: radvd
  file:
    - absent
    - name: /etc/radvd.conf
