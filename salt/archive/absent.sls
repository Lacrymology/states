{#- Usage of this is governed by a license that can be found in doc/license.rst -#}

salt_archive:
  user:
    - absent
    - require:
      - file: salt_archive
  group:
    - absent
    - require:
      - user: salt_archive
  file:
    - absent
    - name: /var/lib/salt_archive

apt-mirror:
  pkg:
    - purged
  file:
    - absent
    - names:
      - /etc/apt/mirror.list
      - /var/spool/apt-mirror
    - require:
      - pkg: apt-mirror
  user:
    - absent
    - require:
      - pkg: apt-mirror
  group:
    - absent
    - require:
      - pkg: apt-mirror

/etc/nginx/conf.d/salt_archive.conf:
  file:
    - absent

{#- old version of states #}
/etc/cron.hourly/salt_archive:
  file:
    - absent

/usr/local/bin/salt_archive_incoming.py:
  file:
    - absent

/etc/cron.d/salt-archive:
  file:
    - absent

salt-archive-clamav:
  file:
    - absent
    - name: /usr/local/bin/salt_archive_clamav.py

/usr/local/bin/salt_archive_clamav.sh:
  file:
    - absent

/usr/local/bin/salt_archive_set_owner_mode.sh:
  file:
    - absent

{{ opts['cachedir'] }}/sync_timestamp.dat:
  file:
    - absent

/var/cache/salt/master/sync_timestamp.dat:
  file:
    - absent

/etc/salt-archive-clamav.yml:
  file:
    - absent
