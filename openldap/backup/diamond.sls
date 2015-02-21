{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.diamond
  - cron.diamond

{%- from 'backup/client/diamond.jinja2' import backup_diamond_resources with context %}
{{ backup_diamond_resources('openldap') }}
