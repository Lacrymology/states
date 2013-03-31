include:
  - diamond
  - nrpe

{#
 first: install memcached and get rid of SysV startup script.
 and remove it's config file.
#}
memcached:
  pkg:
    - installed
  module:
    - wait
    - name: cmd.run
    - cmd: /etc/init.d/memcached stop
    - watch:
      - pkg: memcached
  cmd:
    - wait
    - name: update-rc.d -f memcached remove
    - watch:
      - module: memcached
  file:
    - absent
    - name: /etc/init.d/memcached
    - watch:
      - cmd: memcached
  service:
    - running
    - name: memcached
    - enable: True
    - require:
      - file: memcached
    - watch:
      - file: upstart_memcached

/etc/memcached.conf:
  file:
    - absent
    - require:
      - pkg: memcached

{#
 Create upstart config and start from it.
 #}
upstart_memcached:
  file:
    - managed
    - name: /etc/init/memcached.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://memcache/upstart.jinja2
    - require:
      - file: memcached

/etc/nagios/nrpe.d/memcache.cfg:
  file:
    - managed
    - template: jinja
    - user: nagios
    - group: nagios
    - mode: 440
    - source: salt://memcache/nrpe.jinja2

memcached_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[memcached]]
        name = ^memcached$

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
