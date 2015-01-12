{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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

/usr/local/diamond/salt-redis-requirements.txt:
  file:
    - absent

diamond_redis:
  file:
    - managed
    - name: {{ opts['cachedir'] }}/pip/redis.diamond
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
    - requirements: {{ opts['cachedir'] }}/pip/redis.diamond
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
