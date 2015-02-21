{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

rsync:
  pkg:
    - purged

/etc/rsyncd.conf:
  file:
    - absent
    - require:
      - pkg: rsync

/etc/xinetd.d/rsync:
  file:
    - absent
    - require:
      - pkg: rsync
