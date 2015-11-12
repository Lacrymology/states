Monitor
=======

.. |deployment| replace:: youtrack

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``youtrack``.

Mandatory
---------

.. _monitor-youtrack_procs:

youtrack_procs
~~~~~~~~~~~~~~

:doc:`/youtrack/doc/index` daemon provides the whole
:doc:`/youtrack/doc/index` services and Web interface.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-youtrack_port:

youtrack_port
~~~~~~~~~~~~~

:doc:`/youtrack/doc/index` :ref:`glossary-daemon` :ref:`glossary-HTTP` Port is
listening locally.

.. _monitor-youtrack_http:

youtrack_http
~~~~~~~~~~~~~

:doc:`/youtrack/doc/index` :ref:`glossary-daemon` :ref:`glossary-HTTP` port
works properly.

.. include:: /nginx/doc/monitor.inc

Optional
--------

.. include:: /nginx/doc/monitor_ssl.inc

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
