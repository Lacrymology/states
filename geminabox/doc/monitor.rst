Monitor
=======

Mandatory
---------

.. |deployment| replace:: geminabox

.. include:: /uwsgi/doc/monitor.inc

.. include:: /nginx/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc

.. include:: /backup/doc/monitor.inc

Optional
--------

Only use if :ref:`pillar-geminabox-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
