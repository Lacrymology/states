Pillar
======

Mandatory
---------

roundcube:
  hostnames:
    - list of hostname, used for nginx config
  password:  password for postgresql user "roundcube"

Optional
--------

roundcube:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

Default: False

roundcube:ssl
~~~~~~~~~~~~~

name of SSL used for HTTPS
Default: False

roundcube:workers
~~~~~~~~~~~~~~~~~

number or uwsgi workers
Default: 2

roundcube:cheaper
~~~~~~~~~~~~~~~~

set uwsgi cheaper mode or not
Default: not use
