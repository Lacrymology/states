Pillar
======

.. include:: /doc/include/add_pillar.inc

Mandatory
---------

Example::

  btcd:
    rpcuser: user
    rpcpass: pass

btcd:rpcuser
~~~~~~~~~~~~

The username use for authentication to :ref:`glossary-RPC` server.

btcd:rpcpass
~~~~~~~~~~~~

The password use for authentication to :ref:`glossary-RPC` server.


Optional
--------

Example::

  btcd:
    listen: 127.0.0.1:8333
    rpclisten: 127.0.0.1:8334

.. _pillar-btcd-listen:

btcd:listen
~~~~~~~~~~~

Instruct :doc:`index` which interface and port to listen to connection.

Default: all available interfaces and default port (``:8333``).

.. _pillar-btcd-rpclisten:

btcd:rpclisten
~~~~~~~~~~~~~~

Instruct :doc:`index` which interface and port to listen to :ref:`glossary-RPC`
connection.

Default: all available interfaces and default port (``:8334``).
