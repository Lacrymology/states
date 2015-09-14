{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

clamav-daemon:
  service:
    - dead
  pkg:
    - purged
    - name: clamav-base
    - require:
      - cmd: clamav-freshclam
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

clamav-freshclam:
  service:
    - dead
    - require:
      - service: clamav-daemon
  {#- During CI test, there is a case when freshclam is updating the database
  It forked a new process to do it and for some reasons, `service stop` cannot
  stop all of them. That make `clamav` user failed to remove #}
  cmd:
    - run
    - name: pkill -u clamav freshclam
    - onlyif: pgrep -u clamav freshclam
    - require:
      - service: clamav-freshclam

/var/lib/clamav:
  file:
    - absent
    - require:
      - service: clamav-freshclam

/etc/cron.daily/zz_clamav_scan:
  file:
    - absent
