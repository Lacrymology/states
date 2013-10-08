Pillar
======

Mandatory
---------

Example::

  dns_proxy:
    dns_server: resolv.conf

dns_proxy:dns_server
~~~~~~~~~~~~~~~~~~~~~

To enable status control if you are using resolv.conf.

Optional
--------

Example::

  dns_proxy:
    ip_address: 0.0.0.0
    minimum_ttl: 900
    maximum_ttl: 604800

dns_proxy:ip_address
~~~~~~~~~~~~~~~~~~~~~

The IP address pdnsd listens on for requests.

Default: ``0.0.0.0``.

dns_proxy:minimum_ttl
~~~~~~~~~~~~~~~~~~~~~

The minimum time a record is held in cache.

Default: ``900``.

dns_proxy:maximum_ttl
~~~~~~~~~~~~~~~~~~~~~

The maximum time a record is held in cache.

Default: ``604800``.
