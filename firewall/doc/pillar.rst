Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`

Optional
--------

Example::

  ip_addresses:
    - 192.168.1.1
  firewall:
    filter:
      tcp:
        - 22
        - 80
        - 443

.. _pillar-ip_addresses:

ip_addresses
~~~~~~~~~~~~

List of additional hosts inside that will get full access to this server.

Default: Unused (empty list ``[]``).

.. _pillar-firewall-filter:

firewall:filter
~~~~~~~~~~~~~~~

Dict of protocol (:ref:`glossary-TCP` and :ref:`glossary-UDP`) with inside it the list of ports that are
allowed from external networks.

Default: Empty dict (``{}``).

Conditional
-----------

.. _pillar-firewall-filter-tcp:

firewall:filter:tcp
~~~~~~~~~~~~~~~~~~~

List of :ref:`glossary-TCP` ports which are allowed to access from outside.

Default: Empty list (``[]``).
