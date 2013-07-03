{#
 Turn off Diamond statistics for Redis
 #}
{% if 'graphite_address' in pillar %}
include:
  - diamond

extend:
  diamond:
    service:
      - watch:
        - file: /etc/diamond/collectors/RedisCollector.conf
{% endif %}

/etc/diamond/collectors/RedisCollector.conf:
  file:
    - absent
