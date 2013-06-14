amavis:
  pkg:
    - purged
    - name: amavisd-new

/etc/amavis:
  file:
    - absent
    - require:
      - pkg: amavisd-new
