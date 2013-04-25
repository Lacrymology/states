{#
 Diamond statistics for RabbitMQ
#}
{% if 'graphite_address' in pillars %}
include:
  - diamond

extend:
  diamond:
    service:
      - watch:
        - file: /etc/diamond/collectors/RabbitMQCollector.conf
{% endif %}

/etc/diamond/collectors/RabbitMQCollector.conf:
  file:
    - absent

/usr/local/diamond/salt-pyrabbit-requirements.txt:
  file:
    - absent
