{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

include:
  - backup.client.base.nrpe.absent

backup_client_nrpe-requirements:
  file:
    - absent
    - name: /usr/local/nagios/backup.client.scp.nrpe-requirements.txt

{# remove file with bad name #}
/usr/local/nagios/backup.client.nrpe-requirements.txt:
  file:
    - absent
