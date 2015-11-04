{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}

{%- set prefix = '/etc/init/' -%}
{%- set upstart_files = salt['file.find'](prefix, name='openvpn-client-*.conf', type='f') -%}
    {%- for filename in upstart_files -%}
        {%- set instance = filename.replace(prefix + 'openvpn-client-', '').replace('.conf', '') %}

{{ upstart_absent('openvpn-client-' + instance) }}

openvpn_client_absent_{{ instance }}:
  file:
    - absent
    - name: /etc/openvpn/client/{{ instance }}
    - require:
      - service: openvpn-client-{{ instance }}
    {%- endfor %}

/etc/openvpn/client:
  file:
    - absent

/var/run/openvpn-client:
  file:
    - absent
