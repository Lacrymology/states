{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}

{%- set upstart_files = salt['file.find'](path='/etc/init/', name='openvpn-*.conf', type='f', print='name') -%}
    {%- for filename in upstart_files -%}
        {%- set instance = filename.replace('openvpn-', '').replace('.conf', '') %}

{{ upstart_absent('openvpn-' + instance) }}

        {%- if loop.last %}
openvpn_absent_last_instance:
        {%- else %}
openvpn_absent_{{ instance }}:
        {%- endif %}
  file:
    - absent
    - name: /etc/openvpn/{{ instance }}
    - require:
      - service: openvpn-{{ instance }}
    {# /var/log/upstart/network-interface- #}

    {%- endfor %}
openvpn:
  pkg:
    - purged
  require:
    - file: openvpn_absent_last_instance

/etc/default/openvpn:
  file:
    - absent
    - require:
      - pkg: openvpn

{%- for type in ('lib', 'run', 'log') %}
/var/{{ type }}/openvpn:
  file:
    - absent
{%- endfor %}

/etc/openvpn:
  file:
    - absent

{{ opts['cachedir'] }}/{{ salt['pillar.get']('openvpn:ca:name') }}.serial:
  file:
    - absent
