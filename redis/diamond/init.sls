{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}

include:
  - diamond
  - redis

redis_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[redis]]
        exe = ^\/usr\/bin\/redis-server$

/etc/diamond/collectors/RedisCollector.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://redis/diamond/config.jinja2
    - require:
      - file: /etc/diamond/collectors
    - watch_in:
      - service: diamond

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/diamond/redis-requirements.txt:
  file:
    - absent

diamond_redis:
  file:
    - managed
    - name: /usr/local/diamond/salt-redis-requirements.txt
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://redis/diamond/requirements.jinja2
    - require:
      - virtualenv: diamond
  module:
    - wait
    - name: pip.install
    - upgrade: True
    - bin_env: /usr/local/diamond
    - requirements: /usr/local/diamond/salt-redis-requirements.txt
    - require:
      - virtualenv: diamond
    - watch:
      - file: diamond_redis
    - watch_in:
      - service: diamond

extend:
  diamond:
    service:
      - require:
        - service: redis
