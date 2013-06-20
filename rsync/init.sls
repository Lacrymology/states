rsync:
  pkg:
    - installed

/etc/rsyncd.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - source: salt://rsync/rsyncd.jinja2
    - require:
      - pkg: rsync

#sysV start script come here


