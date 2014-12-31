{#-
Use of this source code is governed by a BSD license that can be found
in the doc/license.rst file.

Author: Viet Hung Nguyen <hvn@robotinfra.com>
Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>
-#}
clamav-daemon:
  pkg:
    - purged
    - name: clamav-base
    - require:
      - service: clamav-daemon
  service:
    - dead
    - names:
      - clamav-daemon
      - clamav-freshclam
  file:
    - absent
    - name: /etc/clamav
    - require:
      - pkg: clamav-daemon
  user:
    - absent
    - name: clamav
    - require:
      - pkg: clamav-daemon
  group:
    - absent
    - name: clamav
    - require:
      - user: clamav-daemon

/var/lib/clamav:
  file:
    - absent
    - require:
      - pkg: clamav-daemon

/etc/cron.daily/clamav_scan:
  file:
    - absent