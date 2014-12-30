{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
mongodb:
  pkg:
    - purged
    - name: mongodb-10gen
    - require:
      - service: mongodb
  file:
    - absent
    - name: /etc/logrotate.d/mongodb
  service:
    - dead
  user:
    - absent
    - require:
      - pkg: mongodb
  group:
    - absent
    - require:
      - user: mongodb

/etc/mongodb.conf:
  file:
    - absent
    - require:
      - pkg: mongodb

/var/lib/mongodb:
  file:
    - absent
    - require:
      - pkg: mongodb

{% for log in ('mongodb', 'upstart/mongodb.log') %}
/var/log/{{ log }}:
  file:
    - absent
    - pkg:
      - pkg: mongodb
{% endfor %}
