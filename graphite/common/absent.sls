{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - carbon.absent
  - graphite.absent

{% for rootdir in ('/var/log', '/etc', '/usr/local') %}
{{ rootdir }}/graphite:
  file:
    - absent
{% endfor %}

/var/lib/graphite:
  file:
    - absent

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
