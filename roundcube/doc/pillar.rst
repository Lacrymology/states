Pillar
======

Mandatory
---------

Example::

  roundcube:
    hostnames:
      - list of hostname, used for nginx config
    password:  password for postgresql user "roundcube"

Optional
--------

roundcube:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

Default: ``False``.

roundcube:ssl
~~~~~~~~~~~~~

Name of SSL used for HTTPS.

Default: ``False``.

roundcube:workers
~~~~~~~~~~~~~~~~~

Number or uwsgi workers.

Default: ``2``.

roundcube:cheaper
~~~~~~~~~~~~~~~~

Set uwsgi cheaper mode or not.

Default: ``not use``.

