{#-
Copyright (c) 2014, Hung Nguyen Viet
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
