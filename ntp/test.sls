{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - ntp
  - ntp.diamond
  - ntp.nrpe

test:
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('ntp') }}
        NtpdCollector:
            ntpd.delay: True
            ntpd.est_error: True
            ntpd.frequency: True
            ntpd.jitter: True
            ntpd.max_error: True
            ntpd.offset: True
            ntpd.poll: True
            ntpd.reach: True
            ntpd.stratum: False
            ntpd.when: True
    - require:
      - sls: ntp
      - sls: ntp.diamond
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: ntp
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
