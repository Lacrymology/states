{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

-#}
cron:
  pkg:
    - purged

/etc/cron.twice_daily:
  file:
    - absent
    - require:
      - pkg: cron
