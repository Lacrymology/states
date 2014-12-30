{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Quan Tong Anh <quanta@robotinfra.com>
Maintainer: Van Diep Pham <favadi@robotinfra.com>
-#}
{%- from 'cron/test.jinja2' import test_cron with context %}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - openerp
  - openerp.backup
  - openerp.backup.diamond
  - openerp.backup.nrpe
  - openerp.diamond
  - openerp.nrpe

{#- require manually create openerp database first #}
test-backup-openerp:
  file:
    - name: /etc/cron.daily/backup-openerp
    - absent

{%- call test_cron() %}
- sls: openerp
- sls: openerp.backup
- sls: openerp.backup.nrpe
- sls: openerp.diamond
- sls: openerp.nrpe
- file: test-backup-openerp
{%- endcall %}

test:
  monitoring:
    - run_all_checks
    - order: last
    - require:
      - cmd: test_crons
  qa:
    - test
    - name: openerp
    - additional:
      - openerp.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('uwsgi-openerp') }}
{%- if salt['pillar.get']('openerp:company_db', False) %}
    {{ diamond_process_test('openerp') }}
{%- endif %}
    - require:
      - sls: openerp
      - sls: openerp.diamond
