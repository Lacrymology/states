{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.client.{{ salt['pillar.get']('backup_storage') }}.nrpe
  - bash.nrpe
  - cron.nrpe
  - nrpe
  - postgresql.server

{%- from 'nrpe/passive.jinja2' import passive_check with context -%}
{%- call passive_check('openerp.backup') %}
  - service: postgresql
{%- endcall %}

extend:
  check_backup.py:
    file:
      - require:
        - file: nsca-openerp.backup
