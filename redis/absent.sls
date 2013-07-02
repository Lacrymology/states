redis-server:
  service:
    - dead

{% for i in ('redis-server', 'redis-benchmark', 'redis-cli', 'redis-check-dump', 'redis-check-aof',) %}
/usr/local/bin/{{ i }}:
  file:
    - absent
    - require:
      - service: redis-server
{% endfor %}

{% set version = '2.6.14' %}
{% set redis_dir = '/usr/local/redis-' + version %}

{{ redis_dir }}:
  file:
    - absent
    - require:
      - service: redis-server

{% for file in ('/etc/init/redis-server.conf', '/var/lib/redis', '/etc/redis.conf', '/var/run/redis.pid') %}
{{ file }}:
  file:
    - absent
    - require:
      - service: redis-server
{% endfor %}
