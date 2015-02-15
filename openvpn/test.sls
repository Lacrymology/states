{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - openvpn
  - openvpn.diamond
  - openvpn.nrpe
  - salt.minion.deps
  - screen

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
    {%- for tunnel in servers -%}
        {%- set mode = servers[tunnel]['mode'] -%}
        {%- set clients = servers[tunnel]['clients'] | default([]) %}
test_openvpn_{{ tunnel }}:
  diamond:
    - test
    - map:
        OpenVPN:
          openvpn.{{ tunnel }}.clients.connected: True
        {%- if mode == 'static' %}
          openvpn.{{ tunnel }}.global.auth_read_bytes: True
          openvpn.{{ tunnel }}.global.tcp-udp_read_bytes: True
          openvpn.{{ tunnel }}.global.tcp-udp_write_bytes: True
          openvpn.{{ tunnel }}.global.tun-tap_read_bytes: True
          openvpn.{{ tunnel }}.global.tun-tap_write_bytes: True
        {%- else %}
          openvpn.{{ tunnel }}.global.max_bcast-mcast_queue_length: True
        {%- endif %}
    - require:
      - sls: openvpn.diamond
      - sls: openvpn

        {%- if mode == 'tls' -%}
            {%- if clients is iterable and clients | length > 0 -%}
                {%- for client in clients -%}
                    {%- if loop.first %}
test_openvpn_{{ tunnel }}_tls:
  file:
    - directory
    - name: /tmp/openvpn
    - user: root
    - group: root
    - mode: 750
    - require:
      - sls: openvpn
      - monitoring: test
  module:
    - run
    - name: archive.unzip
    - zipfile: /etc/openvpn/{{ tunnel }}/clients/{{ client }}.zip
    - dest: /tmp/openvpn
    - require:
      - file: test_openvpn_{{ tunnel }}_tls
  cmd:
    - wait
    - name: screen -d -m -S test_openvpn openvpn {{ client }}.conf
    - cwd: /tmp
    - require:
      - pkg: screen
    - watch:
      - module: test_openvpn_{{ tunnel }}_tls

test_openvpn_{{ tunnel }}_tls_connect:
  cmd:
    - wait
    {#- Wait 10 seconds for OpenVPN client to connect
    The status file is updated every minute #}
    - name: sleep 70 && grep ^{{ client }} /var/log/openvpn/{{ tunnel }}.log
    - watch:
      - cmd: test_openvpn_{{ tunnel }}_tls

test_openvpn_{{ tunnel }}_tls_cleanup:
  cmd:
    - run
    - name: pkill -f 'openvpn {{ client }}.conf'
    - require:
      - cmd: test_openvpn_{{ tunnel }}_tls_connect

                    {%- endif %}{#- first client cert -#}
                {%- endfor -%}
            {%- endif %}{#- clients is iterable -#}
        {%- endif %}{#- tls mode -#}
    {%- endfor -%}
{%- endif %}{#- servers is iterable #}

extend:
  openvpn_diamond_collector:
    file:
      - require:
        - sls: openvpn
