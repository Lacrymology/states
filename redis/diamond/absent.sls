{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
/etc/diamond/collectors/RedisCollector.conf:
  file:
    - absent

diamond_redis:
  file:
    - absent
    - name: /usr/local/diamond/salt-redis-requirements.txt
