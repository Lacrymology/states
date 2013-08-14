s3cmd:
  pkg:
    - purged

/root/.s3cfg:
  file:
    - absent
    - require:
      - pkg: s3cmd
