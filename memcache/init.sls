{#-
 Author: Bruno Clermont patate@fastmail.cn
 Maintainer: Bruno Clermont patate@fastmail.cn
 
 Install a memcache server
 -#}
include:
  - web
  - apt

{#
 first: install memcached and get rid of SysV startup script.
 and remove it's config file.
#}
memcached:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
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
    - order: 50
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
      - user: web
