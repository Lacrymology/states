{#
 Remove Nagios NRPE check for OpenSSH Server
#}
{% if 'shinken_pollers' in pillars %}
include:
  - nrpe

extend:
  nagios-nrpe-server:
    service:
      - watch:
        - file: /etc/nagios/nrpe.d/ssh.cfg
{% endif %}

/etc/nagios/nrpe.d/ssh.cfg:
  file:
    - absent
