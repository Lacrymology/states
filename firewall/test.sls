{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - firewall
  - firewall.diamond
  - firewall.nrpe

test:
  diamond:
    - test
    - map:
        ConnTrack:
          conntrack.ip_conntrack_count: False
          conntrack.ip_conntrack_max: False
    - require:
      - sls: firewall
      - sls: firewall.diamond
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: firewall
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
