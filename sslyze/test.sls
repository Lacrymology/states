{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - sslyze
  - sslyze.nrpe

nsca-test:
  file:
    - serialize
    - name: /etc/nagios/nsca.d/test.yml
    - require:
      - file: /etc/nagios/nsca.d
    - dataset:
        sslyze:
          command: /usr/lib/nagios/plugins/check_ssl_configuration.py --formula=test --check=sslyze
          arguments:
            host: mail.google.com

test:
  monitoring:
    - run_all_checks
    - order: last
  file:
    - absent
    - name: /etc/nagios/nsca.d/test.yml
    - require:
      - monitoring: test
