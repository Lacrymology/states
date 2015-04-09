Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`

Optional
--------

Example::

  firewall:
    allowed_ips:
      - 192.168.1.1
    filter:
      tcp:
        - 22
        - 80
        - 443
    blacklist:
      - 1.2.3.4
      - 5.6.7.8

.. _pillar-firewall-allowed_ips:

firewall:allowed_ips
~~~~~~~~~~~~~~~~~~~~

List of additional hosts that will get full access to this server.

Default: no host allowed to fully access (empty list ``[]``).

.. _pillar-firewall-filter:

firewall:filter
~~~~~~~~~~~~~~~

Dict of protocol (:ref:`glossary-TCP` and :ref:`glossary-UDP`) with inside it
the list of ports that are allowed from external networks.

Default: Empty dict (``{}``).

.. _pillar-firewall-blacklist:

firewall:blacklist
~~~~~~~~~~~~~~~~~~

List of all IP addresses which will be blocked.

Default: Empty list (``[]``).

Conditional
-----------

.. _pillar-firewall-filter-tcp:

firewall:filter:tcp
~~~~~~~~~~~~~~~~~~~

List of :ref:`glossary-TCP` ports which are allowed to access from outside.

Default: Empty list (``[]``).
