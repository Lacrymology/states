Monitor
=======

Mandatory
---------

.. |deployment| replace:: syncthing

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``syncthing``.

.. _monitor-syncthing_dummy:

syncthing_dummy
~~~~~~~~~~~~~~~

Dummy check to prevent the monitoring of :doc:`index` to become empty, always
success.

.. _monitor-syncthing_procs:

syncthing_procs
~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-syncthing_port:

syncthing_port
~~~~~~~~~~~~~~

Check if :doc:`index` is listening to port :ref:`glossary-TCP`/8384.

Optional
--------

Only use if :ref:`pillar-syncthing-hostnames` is defined.

.. include:: /nginx/doc/monitor.inc

Only use if :ref:`pillar-syncthing-ssl` is turned defined.

.. include:: /nginx/doc/monitor_ssl.inc

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
