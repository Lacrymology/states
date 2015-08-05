Monitor
=======

Mandatory
---------

.. |deployment| replace:: doc.publish

.. include:: /nginx/doc/monitor.inc

Optional
--------

Only use if :ref:`pillar-doc-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc

Only use if :ref:`pillar-ip_version` is set to ``ipv6`` or ``both``.

.. include:: /nginx/doc/monitor_ipv6.inc
