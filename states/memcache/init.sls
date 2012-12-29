include:
  - diamond
  - nrpe

/etc/memcached.conf:
  file.absent

/etc/init.d/memcached:
  cmd:
    - wait
    - name: killall -9 memcached
  file:
    - absent
    - watch:
      - cmd: /etc/init.d/memcached

memcached:
  file:
    - managed
    - name: /etc/init/memcached.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://memcache/upstart.jinja2
    - require:
      - pkg: memcached
  pkg:
    - latest
  service:
    - running
    - enable: True
    - watch:
      - file: memcached
      - pkg: memcached

/etc/nagios/nrpe.d/memcache.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://memcache/nrpe.jinja2

memcached_diamond_memory:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessMemoryCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessMemoryCollector.conf
    - text:
      - |
        [[memcached]]
        name = ^memcached$

{# Fix connection trough unix socket #}
memcached_diamond_collector:
  file:
    - absent
{#    - managed#}
    - name: /etc/diamond/collectors/MemcachedCollector.conf
{#    - template: jinja#}
{#    - user: root#}
{#    - group: root#}
{#    - mode: 440#}
{#    - source: salt://memcache/diamond.jinja2#}

extend:
  diamond:
    service:
      - watch:
        - file: memcached_diamond_collector
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/memcache.cfg
