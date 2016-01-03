Monitor
=======

Mandatory
---------


.. |deployment| replace:: mattermost

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``mattermost``.

.. include:: /nginx/doc/monitor.inc

.. include:: /postgresql/doc/monitor.inc

.. include:: /backup/doc/monitor_postgres_procs.inc

.. include:: /backup/doc/monitor.inc

.. _monitor-mattermost_procs:

mattermost_procs
~~~~~~~~~~~~~~~~

:doc:`/mattermost/doc/index` daemon provides the whole
:doc:`/mattermost/doc/index` services and Web interface.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-mattermost_port:

mattermost_port
~~~~~~~~~~~~~~~

:doc:`/mattermost/doc/index` :ref:`glossary-daemon` :ref:`glossary-HTTP` Port is listening locally.

.. _monitor-mattermost_http:

mattermost_http
~~~~~~~~~~~~~~~

:doc:`/mattermost/doc/index` :ref:`glossary-daemon` :ref:`glossary-HTTP` port works properly.

Optional
--------

.. include:: /nginx/doc/monitor_ssl.inc

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
