{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.client.base
  - bash
  - local
  - ssh.client
{%- set address = salt['pillar.get']('backup_server:address') %}
{%- set is_localhost = address in grains['ipv4'] or address in ('localhost', grains['host']) %}
{%- set backup_fp = salt['pillar.get']('backup_server:fingerprint', False)  %}

{%- if is_localhost %}
  {#- If backup_server address set to localhost (mainly in CI testing), install backup.server first #}
  - backup.server
{%- endif %}

backup-client:
  ssh_known_hosts:
    - present
    - name: {{ address }}
    - user: root
{%- if backup_fp %}
    - fingerprint: {{ backup_fp }}
{%- endif %}
    - require:
      - pkg: openssh-client
{%- if is_localhost %}
    {#- when backup server on the same host, make sure ssh service is running, or ssh_known_hosts can not get its host key. #}
      - service: openssh-server
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
{%- if is_localhost %}
      - file: /var/lib/backup
{%- endif %}
