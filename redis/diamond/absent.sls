{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

/etc/diamond/collectors/RedisCollector.conf:
  file:
    - absent

{{ opts['cachedir'] }}/pip/redis.diamond:
  file:
    - absent
