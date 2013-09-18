{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
rsyslog:
  pkg:
    - purged
    - require:
      - service: rsyslog
  file:
    - absent
    - name: /etc/rsyslog.conf
    - require:
      - pkg: rsyslog
  service:
    - dead
