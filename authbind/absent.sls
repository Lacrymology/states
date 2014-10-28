authbind:
  pkg:
    - purged
  file:
    - absent
    - name: /etc/authbind
    - require:
      - pkg: authbind
