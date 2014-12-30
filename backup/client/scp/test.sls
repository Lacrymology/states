{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
{%- if salt['pillar.get']('backup_server:address') %}
include:
  - backup.client.scp
  - backup.client.scp.nrpe
  - backup.dumb
  - doc

{#- Test monitoring check for `scp`:
    - add ssh public key into localhost
    - run some backup using `scp`
    - remove that key and the backup files
    #}
    {%- if salt['pillar.get']('backup_server:address') in grains['ipv4'] or
           salt['pillar.get']('backup_server:address') in ('localhost', grains['host']) -%}
        {%- from 'ssh/test.sls' import add_key with context -%}
        {%- from 'ssh/test.sls' import remove_key with context %}

{{ add_key() }}
{{ remove_key() }}
    {%- endif %}

test:
  monitoring:
    - run_all_checks
    - order: last
  cmd:
    - run
    - name: /usr/local/bin/backup-store `/usr/local/bin/create_dumb`
    - require:
      - file: /usr/local/bin/backup-store
      - file: /usr/local/bin/create_dumb
    {%- if salt['pillar.get']('backup_server:address') in grains['ipv4'] or
           salt['pillar.get']('backup_server:address') in ('localhost', grains['host']) %}
      - cmd: ssh_add_key
    {%- endif %}
    - require_in:
      - cmd: ssh_remove_key
  file:
    - absent
    - name: /var/lib/backup/{{ salt['pillar.get']('backup_server:subdir', False)|default(grains['id'], boolean=True) }}
    - require:
      - cmd: test
  qa:
    - test_pillar
    - name: backup.client.scp
    - pillar_doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
{%- endif %}
