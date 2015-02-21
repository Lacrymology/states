{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - tomcat.6
  - tomcat.6.diamond
  - tomcat.6.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 15
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('tomcat') }}
    - require:
      - sls: tomcat.6
      - service: diamond
  qa:
    - test
    - name: tomcat
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
