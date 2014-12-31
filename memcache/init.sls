{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'upstart/rsyslog.jinja2' import manage_upstart_log with context -%}
include:
  - apt
  - rsyslog
  - web

{#
 first: install memcached and get rid of SysV startup script.
 and remove it's config file.
#}
/etc/init.d/memcached:
  file:
    - absent
    - watch:
      - cmd: memcached

memcached:
  pkg:
    - installed
    - require:
      - cmd: apt_sources
  user:
    - present
    - name: memcache
    - shell: /bin/false
    - require:
      - pkg: memcached
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
    - managed
    - name: /etc/init/memcached.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://memcache/upstart.jinja2
    - require:
      - file: /etc/init.d/memcached
      - user: web
  service:
    - running
    - name: memcached
    - enable: True
    - order: 50
    - require:
      - file: memcached
    - watch:
      - user: web
      - file: memcached
      - user: memcached

{{ manage_upstart_log('memcached') }}

/etc/memcached.conf:
  file:
    - absent
    - require:
      - pkg: memcached
