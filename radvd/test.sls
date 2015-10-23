{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}

include:
  - doc
  - radvd
  - radvd.diamond
  - radvd.nrpe

test:
  qa:
    - test
    - name: radvd
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
          {{ diamond_process_test('radvd') }}
    - require:
      - sls: radvd
      - sls: radvd.diamond
