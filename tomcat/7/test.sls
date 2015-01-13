{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - tomcat.7
  - tomcat.7.nrpe
  - tomcat.7.diamond

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 30
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('tomcat') }}
    - require:
      - sls: tomcat.7
      - service: diamond
  qa:
    - test
    - name: tomcat
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
