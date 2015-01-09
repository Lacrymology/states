{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}

include:
  - backup.client.base
  - bash
  - local
  - ssh.client
{%- set address = salt['pillar.get']('backup_server:address') %}
{%- if address in grains['ipv4'] or
       address in ('localhost', grains['host']) %}
  {#- If backup_server address set to localhost (mainly in CI testing), install backup.server first #}
  - backup.server
{%- else %}

backup-client:
  ssh_known_hosts:
    - present
    - name: {{ address }}
    - user: root
    - fingerprint: {{ salt['pillar.get']('backup_server:fingerprint') }}
    - require:
      - pkg: openssh-client
{%- endif %}

/usr/local/bin/backup-store:
  pkg:
    - installed
    - name: rsync
  file:
    - managed
    - user: root
    - group: root
    - mode: 550
    - template: jinja
    - source: salt://backup/client/scp/copy.jinja2
    - require:
      - file: /usr/local
      - file: bash
      - pkg: /usr/local/bin/backup-store
{%- if address in grains['ipv4'] or
       address in ('localhost', grains['host']) %}
      - file: /var/lib/backup
{%- endif %}

extend:
  openssh-client:
    file:
      - source: salt://backup/client/scp/config.jinja2
