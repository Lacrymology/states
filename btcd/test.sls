{#- Usage of this is governed by a license that can be found in doc/license.rst #}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
{%- from 'logrotate/macro.jinja2' import test_logrotate with context %}
include:
  - btcd
  - btcd.nrpe
  - btcd.diamond
  - doc

{{ test_logrotate("/etc/logrotate.d/btcd") }}

test:
  monitoring:
    - run_all_checks
    - require:
      - sls: btcd
      - sls: btcd.nrpe
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test("btcd") }}
    - require:
      - sls: btcd
      - sls: btcd.diamond
  qa:
    - test
    - name: btcd
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
