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
    - test_pillar
    - name: openvpn.client
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

{%- if not salt['pillar.get']('__test__', False) %}
openvpn_client_monitor_doc:
  qa:
    - test_monitor
    - name: openvpn.client
    - monitor_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
{%- endif %}
