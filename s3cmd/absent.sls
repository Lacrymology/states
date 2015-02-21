{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

s3cmd:
  pkg:
    - purged

/root/.s3cfg:
  file:
    - absent
    - require:
      - pkg: s3cmd
