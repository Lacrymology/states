{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
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
