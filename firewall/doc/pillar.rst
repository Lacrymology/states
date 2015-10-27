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
    allowed_protocols:
      - gre
      - 89
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

Default: no host allowed to fully access (``[]``).

.. _pillar-firewall-allowed_ip6s:

firewall:allowed_ip6s
~~~~~~~~~~~~~~~~~~~~~

List of additional :ref:`glossary-IPv6` addresses that will get full access to
this server.

Default: no host allowed to fully access (``[]``).

.. _pillar-firewall-allowed_protocols:

firewall:allowed_protocols
~~~~~~~~~~~~~~~~~~~~~~~~~~

List of `protocol names or numbers
<http://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml>`_
that will be allowed to reach this server.

Default: do not allow any additional protocol (``[]``).

.. _pillar-firewall-filter:

firewall:filter
~~~~~~~~~~~~~~~

Dict of protocol (:ref:`glossary-TCP` and :ref:`glossary-UDP`) with inside it
the list of ports that are allowed from external networks.

Default: do not allow to access any ports from outside (``{}``).

.. _pillar-firewall-filter6:

firewall:filter6
~~~~~~~~~~~~~~~~

Same as :ref:`pillar-firewall-filter` but with :ref:`glossary-IPv6`.

Default: do not allow to access any ports from outside (``{}``).

.. _pillar-firewall-blacklist:

firewall:blacklist
~~~~~~~~~~~~~~~~~~

List of all IP addresses which will be blocked.

Default: do not block any IP (``[]``).

.. _pillar-firewall-blacklist6:

firewall:blacklist6
~~~~~~~~~~~~~~~~~~~

List of all :ref:`glossary-IPv6` addresses which will be blocked.

Default: do not block any IP (``[]``).

Conditional
-----------

.. _pillar-firewall-filter-tcp:

firewall:filter:tcp
~~~~~~~~~~~~~~~~~~~

List of :ref:`glossary-TCP` ports which are allowed to access from outside.

Default: do not allow to access any :ref:`glossary-TCP` ports from outside
(``[]``).

.. _pillar-firewall-filter-udp:

firewall:filter:udp
~~~~~~~~~~~~~~~~~~~

List of :ref:`glossary-UDP` ports which are allowed to access from outside.

Default: do not allow to access any :ref:`glossary-UDP` ports from outside
(``[]``).
