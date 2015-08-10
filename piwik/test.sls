{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - piwik
  - piwik.nrpe
  - piwik.diamond

test:
  monitoring:
    - run_all_checks
    - require:
      - sls: piwik
      - sls: piwik.nrpe
      - sls: piwik.diamond
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('uwsgi-piwik') }}
    - require:
      - sls: piwik
      - sls: piwik.diamond
  qa:
    - test
    - name: piwik
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
