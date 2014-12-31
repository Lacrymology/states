{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
include:
  - backup.diamond
  - cron.diamond

{%- from "postgresql/server/backup/diamond.jinja2" import postgresql_backup_diamond with context -%}
{{ postgresql_backup_diamond('roundcube') }}
