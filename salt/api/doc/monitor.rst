Monitor
=======

.. |deployment| replace:: salt.api

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``salt_api``.

Mandatory
---------

.. _monitor-salt_api_procs:

salt_api_procs
~~~~~~~~~~~~~~

:doc:`/salt/api/doc/index` daemon provides RESTFUL API for
:doc:`/salt/master/doc/index`.

.. include:: /nrpe/doc/check_procs.inc

.. include:: /nginx/doc/monitor.inc

Optional
--------

.. include:: /nginx/doc/monitor_ssl.inc
