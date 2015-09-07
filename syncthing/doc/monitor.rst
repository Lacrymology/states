Monitor
=======

Mandatory
---------

.. |deployment| replace:: syncthing

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``syncthing``.

.. include:: /nginx/doc/monitor.inc

Optional
--------

Only use if :ref:`pillar-syncthing-ssl` is turned defined.

.. include:: /nginx/doc/monitor_ssl.inc

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
