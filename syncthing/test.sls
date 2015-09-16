{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - syncthing
  - syncthing.nrpe
  - syncthing.diamond

test:
  monitoring:
    - run_all_checks
    - require:
      - sls: syncthing
      - sls: syncthing.nrpe
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('syncthing') }}
    - require:
      - sls: syncthing
      - sls: syncthing.diamond
  qa:
    - test
    - name: syncthing
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  cmd:
    - script
    - source: salt://syncthing/generate.sh
    - require:
      - sls: syncthing
