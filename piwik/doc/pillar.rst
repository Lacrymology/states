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

.. _pillar-piwik-hostnames:

piwik:hostnames
~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

.. _pillar-piwik-db-password:

piwik:db:password
~~~~~~~~~~~~~~~~~

Password of the :doc:`/mysql/doc/index` account.

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
