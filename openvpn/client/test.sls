{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - openvpn.client
  - openvpn.client.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: openvpn.client
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
