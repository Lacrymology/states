{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

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
