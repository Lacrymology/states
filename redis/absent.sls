{#
Uninstall Redis
#}

redis:
  pkg:
    - purged
    - pkgs:
      - redis-server
      - libjemalloc1
    - require:
      - service: redis
  service:
    - dead
    - name: redis-server

{% for filename in ('/var/log', '/etc') %}
{{ filename }}/redis:
  file:
    - absent
    - require:
      - pkg: redis
{% endfor %}
