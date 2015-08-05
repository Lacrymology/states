Monitor
=======

Mandatory
---------

.. |deployment| replace:: etherpad

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``etherpad``.

.. include:: /postgresql/doc/monitor.inc

.. include:: /nginx/doc/monitor.inc

.. _monitor-etherpad_procs:

etherpad_procs
~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Process ``node_modules/ep_etherpad-lite`` running by user ``etherpad``.

.. _monitor-etherpad_port:

etherpad_port
~~~~~~~~~~~~~

Monitor :doc:`index` port :ref:`glossary-TCP` ``9001``.

.. _monitor-etherpad_logger:

etherpad_logger
~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_postgres_procs.inc

Optional
--------

Only use if :ref:`pillar-etherpad-ssl` is defined.

.. include:: /nginx/doc/monitor_ssl.inc

.. _pillar-etherpad_javascript_http:

etherpad_javascript_http
~~~~~~~~~~~~~~~~~~~~~~~~

Monitor :doc:`index` functionality by request to a javascript
:ref:`glossary-URL`.

Only use if :ref:`pillar-__test__` is ``True``.

etherpad_javascript_https
~~~~~~~~~~~~~~~~~~~~~~~~~

Same as :ref:`pillar-etherpad_javascript_http` but connect via
:doc:`/ssl/doc/index`.

Only use if :ref:`pillar-__test__` is ``True`` and if :ref:`pillar-etherpad-ssl`
is defined.

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
