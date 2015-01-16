{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - s3cmd
  - s3cmd.diamond
  - s3cmd.nrpe

{#- can't test diamond metrics, s3cmd is not a daemon #}
test:
  cmd:
    - run
    - name: s3cmd ls
    - require:
      - pkg: s3cmd
  monitoring:
    - run_all_checks
    - order: last
  qa:
    - test_pillar
    - name: s3cmd
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
