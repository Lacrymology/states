{% for rootdir in ('/var/log', '/etc', '/usr/local') %}
{{ rootdir }}/graphite:
  file:
    - absent
{% endfor %}

graphite:
  group:
    - absent
  user:
    - absent
    - require:
      - group: graphite
