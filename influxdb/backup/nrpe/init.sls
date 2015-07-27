{#- Usage of this is governed by a license that can be found in doc/license.rst -#}
{%- from 'nrpe/passive.jinja2' import passive_check with context %}

include:
  - backup.client.{{ salt['pillar.get']('backup_storage') }}.nrpe
  - bash.nrpe
  - cron.nrpe
  - influxdb.nrpe

{{ passive_check('influxdb.backup') }}
