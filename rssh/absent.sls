rssh:
  pkg:
    - purged
  file:
    - absent:
    - name: /etc/rssh.conf
    - require:
      - pkg: rssh
