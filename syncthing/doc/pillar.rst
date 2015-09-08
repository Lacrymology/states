Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`

Mandatory
---------

Example::

  syncthing:
    hostnames:
      - syncthing.example.com
    password: mypassword

.. _pillar-syncthing-hostnames:

syncthing:hostnames
~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

syncthing:password
~~~~~~~~~~~~~~~~~~

Password for :doc:`index` ``admin`` account.

Optional
--------

Example::

  syncthing:
    ssl: syncthing.example.com
    ssl_redirect: True

.. _pillar-syncthing-ssl:

syncthing:ssl
~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-syncthing-ssl_redirect:

syncthing:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc
