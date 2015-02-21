{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.client.base.nrpe.absent

/etc/nagios/s3lite.yml:
  file:
    - absent

/usr/lib/nagios/plugins/check_backup_s3lite.py:
  file:
    - absent
