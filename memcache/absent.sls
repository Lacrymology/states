{#
 Uninstall memcache
 #}
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
