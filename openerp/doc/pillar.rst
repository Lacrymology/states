Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/pip/doc/index` :doc:`/pip/doc/pillar`
- :doc:`/postgresql/doc/index` :doc:`/postgresql/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Mandatory
---------

Example::

  openerp:
    hostnames:
      - openerp.example.com
    password: openerppasswd

.. _pillar-openerp-hostnames:

openerp:hostnames
~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

.. _pillar-openerp-password:

openerp:password
~~~~~~~~~~~~~~~~

The master password to manage databases.

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
    max_upload_file_size: 1

.. _pillar-openerp-ssl:

openerp:ssl
~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-openerp-ssl_redirect:

openerp:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

.. _pillar-openerp-db-name:

openerp:db:name
~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/name.inc

Default: ``openerp``.

.. _pillar-openerp-db-username:

openerp:db:username
~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/username.inc

Default: ``openerp``.

.. _pillar-openerp-db-password:

openerp:db:password
~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/password.inc

.. |deployment| replace:: openerp

.. include:: /uwsgi/doc/pillar.inc

.. _pillar-openerp-max_upload_file_size:

openerp:max_upload_file_size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sets the maximum allowed size of the client request body,
specified in the "Content-Length"
`HTTP <https://en.wikipedia.org/wiki/Http>`__ request header field.
Unit is in megabytes.

Default: only allow request with size less than or equal to ``1`` MB.

.. _pillar-openerp-company_db:

openerp:company_db
~~~~~~~~~~~~~~~~~~

Which database to use to run scheduled jobs.

Default: don't run scheduled jobs (``False``).

.. _pillar-openerp-sentry_dsn:

openerp:sentry_dsn
~~~~~~~~~~~~~~~~~~

.. include:: /sentry/doc/dsn.inc
