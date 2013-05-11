{#
 Uninstall a MongoDB NoSQL server.
#}

{# TODO: remove apt_repository #}

mongodb:
  pkg:
{% if pillar['destructive_absent']|default(False) %}
    - purged
{% else %}
    - removed
{% endif %}
    - name: mongodb-10gen
    - require:
      - service: mongodb
  file:
    - absent
    - name: /etc/logrotate.d/mongodb
  service:
    - dead
    - enable: False
