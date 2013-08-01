{#
 Remove Nagios NRPE check for Backup Server
#}
/etc/nagios/nrpe.d/backups.cfg:
  file:
    - absent

/usr/local/bin/check_backups.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_backups.py:
  file:
    - absent

/etc/sudoers.d/nrpe_backups:
  file:
    - absent
