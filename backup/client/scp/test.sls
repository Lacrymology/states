{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

{%- set address = salt['pillar.get']('backup_server:address') %}
{%- if address %}
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
    {%- if address in grains['ipv4'] or
           address in ('localhost', grains['host']) -%}
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
    {%- if address in grains['ipv4'] or
           address in ('localhost', grains['host']) %}
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
    - doc: {{ opts['cachedir'] }}/doc/output
    - require:
      - monitoring: test
      - cmd: doc
{%- endif %}
