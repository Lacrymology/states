clamav-daemon:
  pkg:
    - purged
    - name: clamav-base
    - require:
      - service: clamav-daemon
  service:
    - dead
    - names:
      - clamav-daemon
      - clamav-freshclam
  file:
    - absent
    - name: /etc/clamav
    - require:
      - pkg: clamav-daemon
