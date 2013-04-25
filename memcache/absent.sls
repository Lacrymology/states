{#
 Uninstall memcache
 #}
memcached:
  file:
    - absent
    - name: /etc/memcached.conf
    - require:
      - pkg: memcached
  pkg:
    - purged
