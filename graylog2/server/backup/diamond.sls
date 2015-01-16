{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - backup.diamond
  - cron.diamond

{%- from "mongodb/backup/diamond.jinja2" import mongodb_backup_diamond with context %}
{{ mongodb_backup_diamond('graylog2') }}
