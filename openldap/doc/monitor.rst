Monitor
=======

Mandatory
---------

.. |deployment| replace:: openldap

.. _monitor-openldap_procs:

openldap_procs
~~~~~~~~~~~~~~

:doc:`index` daemon (slapd) is an
`LDAP <http://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol>`_
server

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-openldap_port:

openldap_port
~~~~~~~~~~~~~

:doc:`index` LDAP Port is listening locally.

.. _monitor-openldap_port_ipv6:

openldap_port_ipv6
~~~~~~~~~~~~~~~~~~

:doc:`index` LDAP Port is listening locally using :ref:`glossary-IPv6`.

.. _monitor-openldap_base:

openldap_base
~~~~~~~~~~~~~

A local client is able to
`bind <http://en.wikipedia.org/wiki/
Lightweight_Directory_Access_Protocol#Bind_.28authenticate.29>`_
to :ref:`pillar-ldap-rootdn`. This check returns OK means the
:doc:`index` server can be accessed by a local client and returned
expected query result for the configured query in this check.

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc
