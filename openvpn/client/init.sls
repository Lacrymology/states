{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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

{%- for instance_name, instance in salt['pillar.get']('openvpn_client:instances').iteritems() %}
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
