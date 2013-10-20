Pillar
======

Mandatory
---------

Example::

  openerp:
    hostnames:
      - openerp.example.com

openerp:hostnames
~~~~~~~~~~~~~~~~~

List of HTTP hostname that ends in graphite webapp.

Optional
--------

Example::

  openerp:
    ssl: microsigns
    ssl_redirect: True
    db:
      password: psqluserpass
    workers: 2
    cheaper: 1
    timeout: 30
    idle: 300

openerp:ssl
~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False``.

openerp:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.

openerp:db:password
~~~~~~~~~~~~~~~~~~~

PostgreSQL user password.

openerp:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details
