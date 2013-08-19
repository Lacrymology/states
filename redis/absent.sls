{#
Uninstall Redis
#}

redis:
  pkg:
    - purged
    - name: redis-server
    - require:
      - service: redis
  service:
    - dead
    - name: redis-server

libjemalloc1:
  pkg:
    - purged
    - require:
      - pkg: redis

{% for filename in ('/var/log', '/etc') %}
{{ filename }}/redis:
  file:
    - absent
    - require:
      - pkg: redis
{% endfor %}
