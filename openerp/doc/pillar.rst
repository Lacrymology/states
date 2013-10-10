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
    database:
      password: psqluserpass
    workers: 2
    cheaper: 1

openerp:ssl
~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False`` by default of that pillar key.

openerp:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False`` by default of that pillar key.

openerp:database:password
~~~~~~~~~~~~~~~~~~~~~~~~~

PostgreSQL user password.

openerp:workers
~~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.

Default: ``2`` by default of that pillar key.

openerp:cheaper
~~~~~~~~~~~~~~~

Number of process in uWSGI cheaper mode. Default no cheaper mode.

See: http://uwsgi-docs.readthedocs.org/en/latest/Cheaper.html.

Default: ``1`` by default of that pillar key.
