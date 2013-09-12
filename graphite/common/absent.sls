include:
  - carbon.absent
  - graphite.absent

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

{%- set prefix = '/etc/init.d/' %}
{%- set init_files = salt['file.find'](prefix, name='carbon-cache-*', type='f') %}
graphite:
  user:
    - absent
    - require:
{% for filename in init_files %}
  {% set instance = filename.replace(prefix + 'carbon-cache-', '') %}
      - service: carbon-cache-{{ instance }}
{% endfor %}
      - service: carbon-relay

{# as long as https://github.com/saltstack/salt/issues/5001 isn't fixed #}
{#
  group:
    - absent
    - require:
      - user: graphite
#}
