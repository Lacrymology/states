{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - doc
  - influxdb
  - influxdb.diamond
  - influxdb.nrpe
  - influxdb.backup
  - influxdb.backup.diamond
  - influxdb.backup.nrpe

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - sls: influxdb
      - sls: influxdb.diamond
      - sls: influxdb.nrpe
      - sls: influxdb.backup.diamond
      - sls: influxdb.backup.nrpe
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('influxdb') }}
    - require:
      - sls: influxdb
      - sls: influxdb.diamond
      - sls: influxdb.backup.diamond
  qa:
    - test
    - name: influxdb
    - additional:
      - influxdb.backup
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
