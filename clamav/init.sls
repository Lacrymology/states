{#-
Clamav: A virus scanner
=============================

Mandatory Pillar
----------------

Optional Pillar
---------------

clamav:
  dns_db:
    - current.cvd.clamav.net
  connect_timeout: 30
  receive_timeout: 30
  times_of_check: 24
  db_mirrors:
    - db.local.clamav.net
    - database.clamav.net


clamav:dns_db: database verification domain, DNS used to verify virus database version.
clamav:connect_timeout: timeout in seconds when connecting to database server.
clamav:receive_timeout: timeout in seconds when reading from database server.
clamav:times_of_check: numbers of database checks per day
clamav:db_mirrors: tuple of spam database servers
-#}
include:
  - apt

clamav-daemon:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  service:
    - running
    - names:
      - clamav-daemon
      - clamav-freshclam
    - watch:
      - file: clamav-daemon
      - pkg: clamav-daemon
  file:
    - managed
    - name: /etc/clamav/freshclam.conf
    - source: salt://clamav/freshclam.jinja2
    - template: jinja
    - mode: 400
    - user: clamav
    - group: clamav
    - require:
      - pkg: clamav-daemon
