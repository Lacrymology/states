..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Quan Tong Anh <quanta@robotinfra.com>

PDNSD
=====

Introduction
------------

PDNSD is a caching :ref:`glossary-dns` proxy server created originally by Thomas Moestl and
currently maintained by Paul Rombouts.

PDNSD is configurable by a config file or using the program pdns-ctl that comes
with the package. Unlike BIND, pdnsd stores cached :ref:`glossary-dns` records on disk for long
term retention and will not purge the cache upon program startup or shutdown.
PDNSD is designed to be highly adaptable to situations where net connectivity is
slow, unreliable, unavailable, or highly dynamic, as is the case with wifi
hotspots or dialup internet. This program also has limited capability of acting
as an authoritative nameserver for a local :ref:`glossary-dns` zone within a private network.

.. Copied from http://en.wikipedia.org/wiki/Pdnsd - 2015-01-22

Links
-----

* `PDNSD Homepage <http://members.home.nl/p.a.rombouts/pdnsd/>`_
* `Wikipedia <http://en.wikipedia.org/wiki/Pdnsd>`_
* `Wiki Archlinux <https://wiki.archlinux.org/index.php/pdnsd>`_

Related Formulas
----------------

* :doc:`/apt/doc/index`

Content
-------

.. toctree::
    :glob:

    *
