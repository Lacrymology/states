Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`

Optional
--------

Example::

  pdnsd:
    sections:
      isp:
        - 1.2.3.4
        - 5.6.7.8
      google:
        - 8.8.8.8
        - 8.8.4.4
    ip_address: 0.0.0.0
    minimum_ttl: 900
    maximum_ttl: 604800

pdnsd:sections
~~~~~~~~~~~~~~

Define multiple server sections. Each section specifies a list of DNS
servers that pdnsd should try to get information from.

If defined, it makes :doc:`/pdnsd/doc/index` behave like a caching,
recursive DNS server.

Default: empty dictionary  (``{}``), which mean use ``/etc/resolv.conf`` and
automatically configure from DNS servers listed there.

pdnsd:ip_address
~~~~~~~~~~~~~~~~

The IP address daemon listens on for requests.

Default: listen on all interfaces (``0.0.0.0``).

pdnsd:minimum_ttl
~~~~~~~~~~~~~~~~~

The minimum time a record is held in cache.

Default: ``900`` seconds.

pdnsd:maximum_ttl
~~~~~~~~~~~~~~~~~

The maximum time a record is held in cache.

Default: ``604800`` seconds.
