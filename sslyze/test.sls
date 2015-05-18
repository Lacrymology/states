{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - sslyze
  - sslyze.nrpe

nsca-test:
  file:
    - managed
    - name: /etc/nagios/nsca.d/test.yml
    - require:
      - file: /etc/nagios/nsca.d
    - contents: |
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
