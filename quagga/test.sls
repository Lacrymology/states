{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'cron/macro.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}

include:
  - doc
  - quagga
  - quagga.diamond
  - quagga.nrpe

{%- call test_cron() %}
- sls: quagga
- sls: quagga.diamond
- sls: quagga.nrpe
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - wait: 60
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: quagga
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('quagga') }}
    - require:
      - sls: quagga
      - sls: quagga.diamond
