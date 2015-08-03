{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - dhcp.server
  - dhcp.server.nrpe
  - dhcp.server.diamond

test:
  cmd:
    - run
    - name: ip address add 192.168.20.1/24 dev eth0 && ip -6 address add 2001:470:8cc0:9002::1/64 dev eth0
  monitoring:
    - run_all_checks
    - require:
      - sls: dhcp.server
      - sls: dhcp.server.nrpe
      - sls: dhcp.server.diamond
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('dhcp-server') }}
    - require:
      - sls: dhcp.server
      - sls: dhcp.server.nrpe
      - sls: dhcp.server.diamond
  qa:
    - test
    - name: dhcp.server
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

clean:
  cmd:
    - run
    - name: ip address delete 192.168.20.1/24 dev eth0 && ip -6 address delete 2001:470:8cc0:9002::1/64 dev eth0
    - order: latest

extend:
  dhcp-server:
    service:
      - require:
        - cmd: test
