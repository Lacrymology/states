deborphan:
  pkg:
    - purged

dialog:
  pkg:
    - purged
    - require:
      - pkg: deborphan
