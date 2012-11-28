include:
  - diamond
  - nrpe

memcached:
  pkg:
    - latest
  service:
    - running
    - require:
      - pkg: memcached

/etc/nagios/nrpe.d/memcache.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://memcache/nrpe.jinja2

memcached_diamond_collector:
  file:
    - managed
    - name: /etc/diamond/collectors/MemcachedCollector.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://memcache/diamond.jinja2

extend:
  diamond:
    service:
      - watch:
        - file: memcached_diamond_collector
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/memcache.cfg
