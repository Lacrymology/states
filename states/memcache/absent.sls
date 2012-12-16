include:
  - diamond
  - nrpe

memcached:
  file:
    - absent
    - name: /etc/memcached.conf
    - require:
      - file: memcached
  pkg:
    - purged

/etc/nagios/nrpe.d/memcache.cfg:
  file:
    - absent

memcached_diamond_collector:
  file:
    - absent
    - name: /etc/diamond/collectors/MemcachedCollector.conf

extend:
  diamond:
    service:
      - watch:
        - file: memcached_diamond_collector
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/memcache.cfg
