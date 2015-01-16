{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}
openvpn:
  pkg:
    - purged

{%- set prefix = '/etc/init/' -%}
{%- set upstart_files = salt['file.find'](prefix, name='openvpn-*.conf', type='f') -%}
{%- for filename in upstart_files -%}
  {%- set tunnel = filename.replace(prefix + 'openvpn-', '').replace('.conf', '') %}
{{ upstart_absent('openvpn-' + tunnel ) }}

/etc/openvpn/{{ tunnel }}:
  file:
    - absent
    - require:
      - service: openvpn-{{ tunnel }}
    - require_in:
      - file: /etc/openvpn
    {# /var/log/upstart/network-interface- #}

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

/etc/openvpn:
  file:
    - absent
