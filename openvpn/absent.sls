{#
 Uninstall and OpenVPN servers
 #}

openvpn:
  pkg:
    - purged

{%- set prefix = '/etc/init/' -%}
{%- set upstart_files = salt['file.find'](prefix, name='openvpn-*.conf', type='f') -%}
{%- for filename in upstart_files -%}
  {%- set tunnel = filename.replace(prefix + 'openvpn-', '').replace('.conf', '') %}
openvpn-{{ tunnel }}:
  file:
    - absent
    - name: {{ filename }}
    - require:
      - service: openvpn-{{ tunnel }}
  service:
    - dead
    - enable: False
{%- endfor %}

/etc/default/openvpn:
  file:
    - absent
    - require:
      - pkg: openvpn

{%- for type in ('lib', 'log') %}
/var/{{ type }}/openvpn:
  file:
    - absent
{%- endfor %}
