{#
 Remove Nagios NRPE check for APT
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/apt.cfg
{% endif %}

/etc/nagios/nrpe.d/apt.cfg:
  file:
    - absent

/usr/local/bin/check_apt-rc.py:
  file:
    - absent

/usr/lib/nagios/plugins/check_apt-rc.py:
  file:
    - absent
