Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`

Mandatory
---------

Example::

  youtrack:
    hostnames:
      - youtrack.example.com

.. _pillar-youtrack-hostnames:

youtrack:hostnames
~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

Example::

  youtrack:
    ssl: example_com
    ssl_redirect: True
    heap_size: 2g

youtrack:heap_size
~~~~~~~~~~~~~~~~~~

Set maximum :doc:`/java/doc/index` heap size ``-Xmx``

Format: <size>[g|G|m|M|k|K].

Default: 1 gigabytes (``1g``).

.. _pillar-youtrack-ssl:

youtrack:ssl
~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-youtrack-ssl_redirect:

youtrack:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc
