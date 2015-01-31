{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.
-#}
{%- from "upstart/absent.sls" import upstart_absent with context -%}

{%- set prefix = '/etc/init/' -%}
{%- set upstart_files = salt['file.find'](prefix, name='openvpn-*.conf', type='f') -%}
    {%- for filename in upstart_files -%}
        {%- set instance = filename.replace(prefix + 'openvpn-', '').replace('.conf', '') %}

{{ upstart_absent('openvpn-' + instance) }}

/etc/openvpn/{{ instance }}:
  file:
    - absent
    - require:
      - service: openvpn-{{ instance }}
    {# /var/log/upstart/network-interface- #}

    {%- endfor %}
openvpn:
  pkg:
    - purged

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

{%- for file in ('ca.crt', 'dh' ~ salt['pillar.get']('openvpn:dhparam:key_size', 2048) ~ '.pem') %}
/etc/openvpn/{{ file }}:
  file:
    - absent
{%- endfor %}

/etc/openvpn:
  file:
    - absent

{%- set ca_name = salt['pillar.get']('openvpn:ca:name') %}
/etc/pki/{{ ca_name }}:
  file:
    - absent

/etc/pki:
  cmd:
    - run
    - name: rm -fr /etc/pki
    - unless: test -A /etc/pki
    - require:
      - file: /etc/pki/{{ ca_name }}

{{ opts['cachedir'] }}/{{ ca_name }}.serial:
  file:
    - absent
