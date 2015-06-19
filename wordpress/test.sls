{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- from 'diamond/macro.jinja2' import diamond_process_test with context %}
include:
  - doc
  - wordpress
  - wordpress.backup
  - wordpress.backup.diamond
  - wordpress.backup.nrpe
  - wordpress.diamond
  - wordpress.nrpe

test:
  monitoring:
    - run_all_checks
    - require:
      - sls: wordpress
      - sls: wordpress.diamond
      - sls: wordpress.nrpe
  diamond:
    - test
    - map:
        ProcessResources:
    {{ diamond_process_test('uwsgi-wordpress', zmempct=False) }}
    - require:
      - sls: wordpress
      - sls: wordpress.diamond
  qa:
    - test
    - name: wordpress
    - additional:
      - wordpress.backup
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
  cmd:
    - run
    - name: /etc/cron.daily/backup-wordpress
    - require:
      - sls: wordpress
      - sls: wordpress.backup
