Monitor
=======

Mandatory
---------

.. |deployment| replace:: openldap

.. _monitor-openldap_procs:

openldap_procs
~~~~~~~~~~~~~~

:doc:`/openldap/doc/index` daemon (slapd) is an
`LDAP <http://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol>`_
server

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-openldap_port:

openldap_port
~~~~~~~~~~~~~

:doc:`/openldap/doc/index` LDAP Port is listening locally.

.. _monitor-openldap_base:

openldap_base
~~~~~~~~~~~~~

A local client is able to `bind <http://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol#Bind_.28authenticate.29>`
to :ref:`pillar-ldap-rootdn`. This check return OK means the
:doc:`/openldap/doc/index` server can be accessed by a local client and returned
expected query result for the configured query in this check.

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc
