Pillar
======

.. include:: /doc/include/add_pillar.inc

.. warning:

  For list of terms, see :doc:`/bind/doc/index`.

Mandatory
---------

Example::

  ddns:
    zone: private.example.com
    nameserver: 192.243.86.11
    tsig_key: xdfydasfsaf+1Q==
    ttl: 3000
    domains:
      {{ grains['id'] }}:
        ips:
          - 1.2.3.4
          - 5.6.7.8
      backup:

.. _pillar-ddns-zone:

ddns:zone
~~~~~~~~~

DNS zone to update https://en.wikipedia.org/wiki/DNS_zone

ddns:nameserver
---------------

IP address of Authoritative name server which serves :ref:`pillar-ddns-zone`.

.. _pillar-ddns-tsig_key:

ddns:tsig_key
~~~~~~~~~~~~~

HMAC-MD5 TSIG key created by dnssec-keygen tool. Used for updating DNS
information dynamically from a remote client.

Optional
--------

.. _pillar-ddns-domains:

ddns:domains
~~~~~~~~~~~~

Data formed as a dictionary with key is the domain and value is the list of the
:ref:`glossary-IP` addresses that will be created as A record.

Default: set host's :doc:`/salt/minion/doc/index` ID (``None``).

.. _pillar-ddns-ttl:

ddns:ttl
~~~~~~~~

TTL for :ref:`pillar-ddns-domains` in unit of seconds.

Default: ``3600`` seconds.

Conditional
-----------

.. _pillar-ddns-domains-domain-ips:

ddns:domains:{{ domain }}:ips
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of :ref:`glossary-IP` addresses that will be used to setup A records for
the domain {{ domain }}.

Default: use the :ref:`glossary-IP` address of the public interface (``None``).
