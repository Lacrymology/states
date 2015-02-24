{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context -%}
{%- from 'macros.jinja2' import dict_default with context %}
include:
  - doc
  - openvpn
  - openvpn.diamond
  - openvpn.nrpe
  - salt.minion.deps

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: openvpn
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('openvpn') }}
    - require:
      - sls: openvpn.diamond
      - sls: openvpn

{%- set servers = salt['pillar.get']('openvpn:servers', {}) -%}
{%- if servers is iterable and servers | length > 0 -%}
    {%- for instance in servers -%}
        {%- set mode = servers[instance]['mode'] -%}
        {{ dict_default(servers[instance], 'clients', []) }}
        {{ dict_default(servers[instance], 'revocations', []) }}
test_openvpn_{{ instance }}:
  diamond:
    - test
    - map:
        OpenVPN:
          openvpn.{{ instance }}.clients.connected: True
        {%- if mode == 'static' %}
          openvpn.{{ instance }}.global.auth_read_bytes: True
          openvpn.{{ instance }}.global.tcp-udp_read_bytes: True
          openvpn.{{ instance }}.global.tcp-udp_write_bytes: True
          openvpn.{{ instance }}.global.tun-tap_read_bytes: True
          openvpn.{{ instance }}.global.tun-tap_write_bytes: True
        {%- else %}
          openvpn.{{ instance }}.global.max_bcast-mcast_queue_length: True
        {%- endif %}
    - require:
      - sls: openvpn.diamond
      - sls: openvpn

        {%- if mode == 'tls' -%}
        {#-
        Testing conectivity by:
          - copy the client cert
          - starting the client
          - change the interval to update the status file every second
          - grep the status file for the client's common name
        -#}
            {%- for client in servers[instance]['clients'] -%}
                {%- if client not in servers[instance]['revocations'] %}
test_openvpn_tls_{{ instance }}_{{ client }}:
  file:
    - directory
    - name: /tmp/openvpn_{{ client }}
    - user: root
    - group: root
    - mode: 750
    - require:
      - sls: openvpn
      - monitoring: test
  module:
    - run
    - name: archive.unzip
    - zipfile: /etc/openvpn/{{ instance }}/clients/{{ client }}.zip
    - dest: /tmp/openvpn_{{ client }}
    - require:
      - file: test_openvpn_tls_{{ instance }}_{{ client }}
  cmd:
    - wait
    - name: nohup openvpn {{ client }}.conf > /dev/null 2>&1 &
    - cwd: /tmp/openvpn_{{ client }}
    - watch:
      - module: test_openvpn_tls_{{ instance }}_{{ client }}

test_openvpn_tls_restart_{{ instance }}_{{ client }}:
  module:
    - run
    - name: service.stop
    - m_name: openvpn-{{ instance }}
    - require:
      - cmd: test_openvpn_tls_{{ instance }}_{{ client }}
  cmd:
    - run
    - name: nohup openvpn --config /etc/openvpn/{{ instance }}/config --status /var/log/openvpn/{{ instance }}.log 1 > /dev/null 2>&1 &
    - require:
      - module: test_openvpn_tls_restart_{{ instance }}_{{ client }}

test_openvpn_tls_connect_{{ instance }}_{{ client }}:
  cmd:
    - wait
    {#- Wait 10 seconds for OpenVPN client to connect
    The status file is updated every second #}
    - name: sleep 11 && grep ^{{ client }} /var/log/openvpn/{{ instance }}.log
    - watch:
      - cmd: test_openvpn_tls_restart_{{ instance }}_{{ client }}

test_openvpn_tls_cleanup_{{ instance }}_{{ client }}:
  cmd:
    - run
    - name: pkill -f 'openvpn {{ client }}.conf'
    - require:
      - cmd: test_openvpn_tls_connect_{{ instance }}_{{ client }}

                {%- endif %}{#- client not in revocations list -#}
            {%- endfor -%}
        {%- endif %}{#- tls mode -#}
    {%- endfor -%}
{%- endif %}{#- servers is iterable #}

extend:
  openvpn_diamond_collector:
    file:
      - require:
        - sls: openvpn
