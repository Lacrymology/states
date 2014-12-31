{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
include:
  - doc
  - salt.archive.server
  - salt.archive.server.diamond
  - salt.archive.server.nrpe

{%- call test_cron() %}
- sls: salt.archive.server
- sls: salt.archive.server.nrpe
{%- endcall %}

test_salt_archive:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: salt.archive.server
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test_salt_archive
      - cmd: doc
