{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - clamav.server
  - clamav.server.apparmor
  - clamav.server.nrpe
  - clamav.server.diamond
  - doc

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}

{%- call test_cron() %}
- file: /usr/local/bin/clamav-scan.sh
- sls: clamav.server.nrpe
- sls: clamav.server.diamond
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
    - require:
      - cmd: test_crons
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('clamav') }}
          {{ diamond_process_test('freshclam') }}
    - require:
      - service: clamav-daemon
      - sls: clamav.server.diamond
  qa:
    - test_pillar
    - name: clamav
    - additional:
      - clamav.server
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc

test_clamav_server:
  qa:
    - test_monitor
    - name: clamav.server
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
