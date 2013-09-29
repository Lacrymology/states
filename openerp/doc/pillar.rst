Pillar
======

Mandatory
---------

openerp:
  hostnames:
    - list of hostname, used for nginx config

Optional
--------

openerp:
  ssl: - enable ssl. Default: False
  database:
    password: password for postgres user
  workers: the number of worker for running web service
