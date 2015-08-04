Monitor
=======

Mandatory
---------

.. |deployment| replace:: apt_cache

.. _monitor-apt_cache_procs:

apt_cache_procs
~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-apt_cache_port:

apt_cache_port
~~~~~~~~~~~~~~

:doc:`index` port :ref:`glossary-TCP` ``3142`` is listening on
:ref:`glossary-localhost`.

.. include:: /nginx/doc/monitor.inc

Optional
--------

Only use if :ref:`pillar-apt_cache-ssl` is set to ``True``.

.. include:: /nginx/doc/monitor_ssl.inc

Only use if :ref:`pillar-ip_version` is set to ``ipv6`` or ``both``.

.. include:: /nginx/doc/monitor_ipv6.inc
