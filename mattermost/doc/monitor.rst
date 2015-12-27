Monitor
=======

.. |deployment| replace:: mattermost

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``mattermost``.

Mandatory
---------

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

.. include:: /nginx/doc/monitor.inc

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc

Optional
--------

.. include:: /nginx/doc/monitor_ssl.inc

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
