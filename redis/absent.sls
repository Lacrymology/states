{#
Uninstall Redis
#}

redis-server:
  pkg:
    - purged
    - pkgs:
      - libjemalloc1
      - libjemalloc-dev
      - redis-server
    - require:
      - service: redis-server
  service:
    - dead

/etc/redis:
  file:
    - absent
    - require:
      - pkg: redis-server
