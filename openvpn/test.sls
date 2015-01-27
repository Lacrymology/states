{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - openvpn
  - openvpn.diamond
  - openvpn.nrpe
  - openvpn.static
  - openvpn.tls

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test_pillar
    - name: openvpn
    - additional:
      - openvpn.tls
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('openvpn') }}
        {%- set tunnel = salt['pillar.get']('openvpn:servers', {}).keys()[0] %}
        OpenVPN:
          openvpn.{{ tunnel }}.clients.connected: True
          openvpn.{{ tunnel }}.global.auth_read_bytes: True
          openvpn.{{ tunnel }}.global.tcp-udp_read_bytes: True
          openvpn.{{ tunnel }}.global.tcp-udp_write_bytes: True
          openvpn.{{ tunnel }}.global.tun-tap_read_bytes: True
          openvpn.{{ tunnel }}.global.tun-tap_write_bytes: True
    - require:
      - sls: openvpn.diamond
      - sls: openvpn.static
      - sls: openvpn.tls

test_monitor:
  qa:
    - test_monitor
    - name: openvpn
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

extend:
  openvpn_diamond_collector:
    file:
      - require:
        - sls: openvpn.static
