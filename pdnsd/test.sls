{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - pdnsd
  - pdnsd.diamond
  - pdnsd.nrpe

test:
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('pdnsd') }}
    - require:
      - sls: pdnsd
      - sls: pdnsd.diamond
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: pdnsd
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
