{#
 Uninstall a RabbtiMQ server
 #}

rabbitmq-server:
  pkg:
{% if pillar['destructive_absent']|default(False) %}
    - purged
{% else %}
    - removed
{% endif %}
    - require:
      - service: rabbitmq-server
  service:
    - dead
    - enable: False

/etc/rabbitmq:
  file:
    - absent
    - require:
      - pkg: rabbitmq-server
