Monitor
=======

.. |deployment| replace:: jenkins

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``jenkins``.

Mandatory
---------

.. _monitor-jenkins_procs:

jenkins_procs
~~~~~~~~~~~~~

:doc:`/jenkins/doc/index` daemon provides the whole
:doc:`/jenkins/doc/index` services and Web interface.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-jenkins_port:

jenkins_port
~~~~~~~~~~~~

:doc:`/jenkins/doc/index` :ref:`glossary-daemon` :ref:`glossary-HTTP` Port is listening locally.

.. _monitor-jenkins_http:

jenkins_http
~~~~~~~~~~~~

:doc:`/jenkins/doc/index` :ref:`glossary-daemon` :ref:`glossary-HTTP` port works properly.

.. include:: /nginx/doc/monitor.inc

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc

Optional
--------

.. include:: /nginx/doc/monitor_ssl.inc

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc

.. _monitor-jenkins_port_ipv6:

jenkins_port_ipv6
~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-jenkins_port` but for :ref:`glossary-IPv6`.

.. _monitor-jenkins_http_ipv6:

jenkins_http_ipv6
~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-jenkins_http` but for :ref:`glossary-IPv6`.
