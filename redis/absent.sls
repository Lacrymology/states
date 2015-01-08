{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
redis:
  pkg:
    - purged
    - pkgs:
      - redis-server
      - libjemalloc1
      - redis-tools
    - require:
      - service: redis
  service:
    - dead
    - name: redis-server
  user:
    - absent
    - force: True
    - purge: True
    - require:
      - pkg: redis
  group:
    - absent
    - require:
      - user: redis

{% for filename in ('/var/log', '/etc') %}
{{ filename }}/redis:
  file:
    - absent
    - require:
      - pkg: redis
{% endfor %}
