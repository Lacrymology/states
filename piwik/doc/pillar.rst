Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/mysql/server/doc/index` :doc:`/mysql/server/doc/pillar`

.. |deployment| replace:: piwik

Mandatory
---------

Example::

  piwik:
    hostnames:
      - mydomain.com
    db:
      password: test
    admin:
      username: admin
      password: adminadmin
      email: admin@example.com

.. _pillar-piwik-hostnames:

piwik:hostnames
~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

.. _pillar-piwik-db-password:

piwik:db:password
~~~~~~~~~~~~~~~~~

Password of the :doc:`/mysql/doc/index` account.

piwik:admin:username
~~~~~~~~~~~~~~~~~~~~

Username for :doc:`index` initial super account.

piwik:admin:password
~~~~~~~~~~~~~~~~~~~~

Password for :doc:`index` initial super account.

piwik:admin:email
~~~~~~~~~~~~~~~~~

Email for :doc:`index` initial super user.

Optional
--------

Example::

  piwik:
    ssl: example.com
    ssl_redirect: True
    workers: 2
    cheaper: 1
    timeout: 60
    idle: 300

.. include:: /uwsgi/doc/pillar.inc

.. _pillar-piwik-ssl:

piwik:ssl
~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-piwik-ssl_redirect:

piwik:ssl_redirect
~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc
