{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
/etc/diamond/collectors/RedisCollector.conf:
  file:
    - absent

diamond_redis:
  file:
    - absent
    - name: /usr/local/diamond/salt-redis-requirements.txt

{#- TODO: remove that statement in >= 2014-04 #}
/usr/local/diamond/redis-requirements.txt:
  file:
    - absent
