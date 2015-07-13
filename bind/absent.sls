{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

bind:
  service:
    - dead
    - name: bind9
  pkg:
    - purged
    - name: bind9
    - require:
      - service: bind

bind_config:
  file:
    - absent
    - name: /etc/bind
    - require:
      - pkg: bind

bind_data:
  file:
    - absent
    - name: /var/lib/bind
    - require:
      - pkg: bind

bind_cache:
  file:
    - absent
    - name: /var/cache/bind
    - require:
      - pkg: bind

/usr/share/bind9:
  file:
    - absent
    - require:
      - pkg: bind
