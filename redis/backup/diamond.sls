{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
include:
  - backup.diamond
  - cron.diamond

{%- from 'backup/client/diamond.jinja2' import backup_diamond_resources with context %}
{{ backup_diamond_resources('redis') }}
