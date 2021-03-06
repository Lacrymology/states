{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - nginx
  - nginx.diamond
  - nginx.nrpe

test:
  diamond:
    - test
    - map:
        Nginx:
          nginx.act_reads: True
          nginx.act_waits: True
          nginx.act_writes: False
          nginx.active_connections: False
          nginx.conn_accepted: True
          nginx.conn_handled: True
          nginx.req_handled: True
          nginx.req_per_conn: False
        ProcessResources:
          {{ diamond_process_test('nginx') }}
    - require:
      - sls: nginx
      - sls: nginx.diamond
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test
    - name: nginx
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
