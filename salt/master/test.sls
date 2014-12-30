{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Bruno Clermont <bruno@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - salt.master
  - salt.master.backup
  - salt.master.backup.nrpe
  - salt.master.diamond
  - salt.master.nrpe

test:
  monitoring:
    - run_all_checks
    - order: last
    - wait: 60
  cmd:
    - run
    - name: /etc/cron.daily/backup-saltmaster
    - require:
      - sls: salt.master
      - sls: salt.master.backup
  qa:
    - test
    - name: salt.master
    - additional:
      - salt.master.backup
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('salt-master', zmempct=False) }}
    - require:
      - sls: salt.master
      - sls: salt.master.diamond
