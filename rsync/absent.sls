{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com
 -#}
rsync:
  pkg:
    - purged
    - require:
      - service: rsync
  file:
    - absent
    - name: /etc/init/rsync.conf
    - require:
      - pkg: rsync
      - service: rsync
  service:
    - dead

/etc/rsyncd.conf:
  file:
    - absent
    - require:
      - pkg: rsync
      - service: rsync
