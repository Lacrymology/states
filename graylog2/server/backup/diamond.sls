{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.diamond
  - cron.diamond

{%- from "mongodb/backup/diamond.jinja2" import mongodb_backup_diamond with context %}
{{ mongodb_backup_diamond('graylog2') }}
