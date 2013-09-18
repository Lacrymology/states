{#-
 Author: Hung Nguyen Viet hvnsweeting@gmail.com
 Maintainer: Hung Nguyen Viet hvnsweeting@gmail.com

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

clamav-freshclam:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
  module:
    - wait
    - name: service.stop
    - m_name: clamav-freshclam
    - watch:
      - pkg: clamav-freshclam
  cmd:
    - wait
    - name: freshclam --stdout -v
    - require:
      - file: clamav-freshclam
      - module: clamav-freshclam
    - watch:
      - pkg: clamav-freshclam
  file:
    - managed
    - name: /etc/clamav/freshclam.conf
    - source: salt://clamav/freshclam.jinja2
    - template: jinja
    - mode: 400
    - user: clamav
    - group: clamav
    - require:
      - pkg: clamav-freshclam
  service:
    - running
    - order: 50
    - require:
      - cmd: clamav-freshclam
    - watch:
      - file: clamav-freshclam
      - pkg: clamav-freshclam

clamav-daemon:
  pkg:
    - latest
    - require:
      - cmd: apt_sources
      - pkg: clamav-freshclam
  service:
    - running
    - order: 50
    - require:
      - service: clamav-freshclam
    - watch:
      - pkg: clamav-daemon

