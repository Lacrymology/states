{#
 Remove Gsyslog configuration for Nagios NRPE
#}
include:
  - gsyslog

/etc/gsyslog.d/nrpe.conf:
  file:
    - absent

extend:
  gsyslog:
    service:
      - watch:
        - file: /etc/gsyslog.d/nrpe.conf
