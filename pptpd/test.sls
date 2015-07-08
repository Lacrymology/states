{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context -%}

include:
  - doc
  - pptpd
  - pptpd.diamond
  - pptpd.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: pptpd
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('pptpd') }}
    - require:
      - sls: pptpd.diamond
      - sls: pptpd
