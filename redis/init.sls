include:
  - build

{% set version = '2.6.14' %}
{% set redis_dir = '/usr/local/redis-' + version %}
redis:
  archive:
    - extracted
    - source: http://redis.googlecode.com/files/redis-2.6.14.tar.gz
    - name: /usr/local
    - tar_options: z
    - archive_format: tar
    - source_hash: md5=02e0c06e953413017ff64862953e2756
    - if_missing: {{ redis_dir }}
  cmd:
    - run
    - cwd: {{ redis_dir }}
    - name: make install 2>&1 > /dev/null
    - unless: test -e /usr/local/bin/redis-server
    - require:
      - archive: redis
      - pkg: build
  file:
    - managed
    - template: jinja
    - source: salt://redis/config.jinja2
    - name: /etc/redis.conf
    - makedirs: True
  service:
    - name: redis-server
    - running
    - watch:
      - file: redis
      - cmd: redis
      - file: redis_upstart
    - require:
      - file: /var/lib/redis

redis_upstart:
  file:
    - managed
    - name: /etc/init/redis-server.conf
    - source: salt://redis/upstart.jinja2
    - user: root
    - group: root
    - mode: 600
    - template: jinja

/var/lib/redis:
  file:
    - directory
    - makedirs: True
    - user: root
    - group: root
    - mode: 550
