{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/diamond/collectors/RedisCollector.conf:
  file:
    - absent

diamond_redis:
  file:
    - absent
    - name: /usr/local/diamond/salt-redis-requirements.txt
