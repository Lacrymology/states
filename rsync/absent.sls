{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
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
