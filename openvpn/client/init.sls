{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - openvpn

{%- set instance = salt['pillar.get']('openvpn_client:server_instance') %}

/etc/openvpn/client:
  file:
    - directory
    - user: root
    - group: root
    - mode: 750
    - require:
      - pkg: openvpn

/etc/openvpn/client/{{ instance }}:
  file:
    - directory
    - user: root
    - group: root
    - mode: 750
    - require:
      - file: /etc/openvpn/client

/etc/openvpn/client/{{ instance }}/ca.crt:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - contents: |
        {{ salt['pillar.get']('openvpn_client:' + instance + ':ca')|indent(8) }}
    - require:
      - file: /etc/openvpn/client/{{ instance }}

/etc/openvpn/client/{{ instance }}/{{ grains['id'] }}.crt:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - contents: |
        {{ salt['pillar.get']('openvpn_client:' + instance + ':crt')|indent(8) }}
    - require:
      - file: /etc/openvpn/client/{{ instance }}

/etc/openvpn/client/{{ instance }}/{{ grains['id'] }}.key:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - contents: |
        {{ salt['pillar.get']('openvpn_client:' + instance + ':key')|indent(8) }}
    - require:
      - file: /etc/openvpn/client/{{ instance }}

/etc/openvpn/client/{{ instance }}/{{ grains['id'] }}.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 400
    - contents: |
        {{ salt['pillar.get']('openvpn_client:' + instance + ':conf')|indent(8) }}
    - require:
      - file: /etc/openvpn/client/{{ instance }}

/var/run/openvpn-client:
  file:
    - directory
    - user: root
    - group: root
    - mode: 770

openvpn_client:
  file:
    - managed
    - name: /etc/init/openvpn-client-{{ instance }}.conf
    - source: salt://openvpn/client/upstart.jinja2
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - context:
        instance: {{ instance }}
  {#-
  There is no way to test openvpn.client via CI currently.
  We can do it later in QA project.
  In the mean time, don't start client service if running in the test mode.
  #}
{%- if not salt['pillar.get']('__test__', False) %}
  service:
    - running
    - name: openvpn-client-{{ instance }}
    - order: 50
    - require:
      - file: /var/run/openvpn-client
    - watch:
      - file: /etc/openvpn/client/{{ instance }}/ca.crt
      - file: /etc/openvpn/client/{{ instance }}/{{ grains['id'] }}.crt
      - file: /etc/openvpn/client/{{ instance }}/{{ grains['id'] }}.key
      - file: /etc/openvpn/client/{{ instance }}/{{ grains['id'] }}.conf
      - file: openvpn_client
{%- endif %}
