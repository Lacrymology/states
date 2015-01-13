{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

MMaintainer: Van Pham Diep <favadi@robotinfra.com>
-#}
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
