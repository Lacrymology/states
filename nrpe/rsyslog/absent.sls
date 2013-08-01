{#
 Remove rsyslog configuration for Nagios NRPE
#}
include:
  - rsyslog

/etc/rsyslog.d/nrpe.conf:
  file:
    - absent

extend:
  rsyslog:
    service:
      - watch:
        - file: /etc/rsyslog.d/nrpe.conf
