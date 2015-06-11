{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
    - purge: True
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
