{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
  file:
    - absent
    - name: /etc/apt/sources.list.d/chris-lea-redis-server.list

{% for filename in ('/var/log', '/etc') %}
{{ filename }}/redis:
  file:
    - absent
    - require:
      - pkg: redis
{% endfor %}
