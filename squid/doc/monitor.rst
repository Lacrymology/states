Monitor
=======

Mandatory
---------

.. _monitor-squid_procs:

squid_procs
~~~~~~~~~~~

:doc:`index` :ref:`glossary-daemon` is main process.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-squid_unlinkd_procs:

squid_unlinkd_procs
~~~~~~~~~~~~~~~~~~~

``unlinkd`` is an external process used for unlinking unused cache files.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-squid_proxy_port:

squid_proxy_port
~~~~~~~~~~~~~~~~

Monitor :doc:`index` port :ref:`glossary-TCP` ``3128``.

.. _monitor-squid_proxy_port_ipv6:

squid_proxy_port_ipv6
~~~~~~~~~~~~~~~~~~~~~

Monitor :doc:`index` port :ref:`glossary-TCP` ``3128`` using
:ref:`glossary-IPv6`.
