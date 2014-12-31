{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - diamond
  - memcache
  - rsyslog.diamond

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
    - source: salt://memcache/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors
    - watch_in:
      - service: diamond

extend:
  diamond:
    service:
      - require:
        - service: memcached
