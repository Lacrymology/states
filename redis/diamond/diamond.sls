{#
 Diamond statistics for redis
#}

include:
  - diamond

rsync_diamond_resources:
  file:
    - accumulated
    - name: processes
    - filename: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - require_in:
      - file: /etc/diamond/collectors/ProcessResourcesCollector.conf
    - text:
      - |
        [[redis]]
        exe = ^\/usr\/local\/bin\/redis-server$

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

extend:
  diamond:
    service:
      - watch:
        - file: /etc/diamond/collectors/RedisCollector.conf
