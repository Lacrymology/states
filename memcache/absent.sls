{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Uninstall memcache
 -#}
memcached:
  service:
    - dead
  file:
    - absent
    - name: /etc/init/memcached.conf
    - require:
      - service: memcached
  pkg:
    - purged
    - require:
      - service: memcached

/tmp/memcached.sock:
  file:
    - absent
    - require:
      - service: memcached
