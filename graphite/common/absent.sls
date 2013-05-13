{% for rootdir in ('/var/log', '/etc', '/usr/local') %}
{{ rootdir }}/graphite:
  file:
    - absent
{% endfor %}

{# as long as https://github.com/saltstack/salt/issues/5001 isn't fixed #}
{% if salt['group.info']('graphite') %}
graphite:
  group:
    - absent
    - require:
      - user: graphite
  user:
    - absent
{% endif %}
