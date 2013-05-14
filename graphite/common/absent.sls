{% for rootdir in ('/var/log', '/etc', '/usr/local') %}
{{ rootdir }}/graphite:
  file:
    - absent
{% endfor %}

{% if pillar['destructive_absent']|default(False) %}
/var/lib/graphite:
  file:
    - absent
{% endif %}

graphite:
  user:
    - absent
{# as long as https://github.com/saltstack/salt/issues/5001 isn't fixed #}
{#
  group:
    - absent
    - require:
      - user: graphite
#}
