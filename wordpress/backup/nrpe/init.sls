{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - bash.nrpe
  - backup.client.{{ salt['pillar.get']('backup_storage') }}.nrpe
  - cron.nrpe
  - nrpe

{%- from 'nrpe/passive.jinja2' import passive_check with context -%}
{{ passive_check('wordpress.backup') }}

extend:
  check_backup.py:
    file:
      - require:
        - file: nsca-wordpress.backup
