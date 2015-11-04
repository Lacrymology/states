{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from "upstart/absent.sls" import upstart_absent with context -%}

include:
  - openvpn

/etc/openvpn/client:
  file:
    - directory
    - user: root
    - group: root
    - mode: 750
    - require:
      - pkg: openvpn

/var/run/openvpn-client:
  file:
    - directory
    - user: root
    - group: root
    - mode: 770

{%- set instances = salt['pillar.get']('openvpn_client:instances') -%}
{%- set upstart_files = salt['file.find']('/etc/init', name='openvpn-client-*.conf', type='f', print='name') -%}
{%- for filename in upstart_files -%}
  {%- set old_instance = filename.replace('openvpn-client-', '').replace('.conf', '') %}

{{ upstart_absent('openvpn-client-' + old_instance) }}

openvpn_client_absent_{{ old_instance }}:
  file:
    - absent
    - name: /etc/openvpn/client/{{ old_instance }}
    - require:
      - service: openvpn-client-{{ old_instance }}
  {%- for instance in instances %}
    {%- if loop.first %}
    - require_in:
    {%- endif %}
      - service: openvpn_client_{{ instance }}
  {%- endfor %}
{%- endfor %}

{%- for instance_name, instance in instances.iteritems() %}
/etc/openvpn/client/{{ instance_name }}:
  file:
    - directory
    - user: root
    - group: root
    - mode: 750
    - require:
      - file: /etc/openvpn/client

/etc/openvpn/client/{{ instance_name }}/ca.crt:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - contents: |
        {{ instance['ca'] | indent(8) }}
    - require:
      - file: /etc/openvpn/client/{{ instance_name }}

/etc/openvpn/client/{{ instance_name }}/{{ grains['id'] }}.crt:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - contents: |
        {{ instance['crt'] | indent(8) }}
    - require:
      - file: /etc/openvpn/client/{{ instance_name }}

/etc/openvpn/client/{{ instance_name }}/{{ grains['id'] }}.key:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - contents: |
        {{ instance['key'] | indent(8) }}
    - require:
      - file: /etc/openvpn/client/{{ instance_name }}

/etc/openvpn/client/{{ instance_name }}/{{ grains['id'] }}.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - contents: |
        # {{ salt['pillar.get']('message_do_not_modify') }}

        dev {{ salt['pillar.get']('openvpn_client:instances:' ~ instance_name ~ ':device') }}
        {{ instance['conf'] | indent(8) }}
    - require:
      - file: /etc/openvpn/client/{{ instance_name }}

openvpn_client_{{ instance_name }}:
  file:
    - managed
    - name: /etc/init/openvpn-client-{{ instance_name }}.conf
    - source: salt://openvpn/client/upstart.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        instance: {{ instance_name }}
  service:
    - running
    - name: openvpn-client-{{ instance_name }}
    - order: 50
    - require:
      - file: /var/run/openvpn-client
    - watch:
      - file: /etc/openvpn/client/{{ instance_name }}/ca.crt
      - file: /etc/openvpn/client/{{ instance_name }}/{{ grains['id'] }}.crt
      - file: /etc/openvpn/client/{{ instance_name }}/{{ grains['id'] }}.key
      - file: /etc/openvpn/client/{{ instance_name }}/{{ grains['id'] }}.conf
      - file: openvpn_client_{{ instance_name }}
{%- endfor %}
