{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

clamav-daemon:
  service:
    - dead
    - names:
      - clamav-daemon
      - clamav-freshclam
  pkg:
    - purged
    - name: clamav-base
    - require:
      - service: clamav-daemon
      - file: /var/lib/clamav
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
      - service: clamav-daemon

/etc/cron.daily/clamav_scan:
  file:
    - absent
