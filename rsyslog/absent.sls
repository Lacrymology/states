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
