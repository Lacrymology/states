{% for rootdir in ('/var/log', '/etc', '/usr/local') %}
{{ rootdir }}/graphite:
  file:
    - absent
{% endfor %}

graphite:
  group:
    - absent
    - require:
      - user: graphite
  user:
    - absent
