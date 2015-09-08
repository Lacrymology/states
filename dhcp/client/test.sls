{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
include:
  - dhcp.client.nrpe
  - doc

test:
  monitoring:
    - run_all_checks
    - exclude:
      - dhcp_offer
    - require:
      - sls: dhcp.client.nrpe
  qa:
    - test_monitor
    - name: dhcp.client
    - monitor_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
