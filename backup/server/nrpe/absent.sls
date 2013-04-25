{#
 Remove Nagios NRPE check for Backup Server
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/backups.cfg
{% endif %}

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
