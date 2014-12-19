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

:doc:`/jenkins/doc/index` daemon HTTP Port is listening locally.

.. _monitor-jenkins_http:

jenkins_http
~~~~~~~~~~~~

:doc:`/jenkins/doc/index` daemon HTTP port works properly.

.. include:: /nginx/doc/monitor.inc

Optional
--------

.. include:: /nginx/doc/monitor_ssl.inc