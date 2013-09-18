{#-
 Author: Nicolas Plessis nicolas@microsigns.com
 Maintainer: Nicolas Plessis nicolas@microsigns.com
 -#}
s3cmd:
  pkg:
    - purged

/root/.s3cfg:
  file:
    - absent
    - require:
      - pkg: s3cmd
