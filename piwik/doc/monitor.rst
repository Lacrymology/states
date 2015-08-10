Monitor
=======

.. |deployment| replace:: piwik

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``wordpress``.

Mandatory
---------

.. include:: /uwsgi/doc/monitor.inc

.. include:: /mysql/doc/monitor.inc

.. include:: /nginx/doc/monitor.inc

Optional
--------

Only use if :ref:`pillar-wordpress-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
