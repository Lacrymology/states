{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Van Pham Diep <favadi@robotinfra.com>

Nagios NRPE check for Sentry backup
-#}
include:
  - backup.client.{{ salt['pillar.get']('backup_storage') }}.nrpe
  - bash.nrpe
  - cron.nrpe
  - nrpe

{%- from 'nrpe/passive.jinja2' import passive_check with context -%}
{{ passive_check('sentry.backup') }}

extend:
  check_backup.py:
    file:
      - require:
        - file: nsca-sentry.backup
