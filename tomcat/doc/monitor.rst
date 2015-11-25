Monitor
=======

Mandatory
---------

.. _monitor-tomcat_procs:

tomcat_procs
~~~~~~~~~~~~

:doc:`index` :ref:`glossary-daemon` run as web server and servlet container
for :doc:`/java/doc/index` application.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-tomcat_port_remote:

tomcat_port_remote
~~~~~~~~~~~~~~~~~~

:doc:`index` :ref:`glossary-HTTP` Port is reachable from outside.

.. _monitor-tomcat_port:

tomcat_port
~~~~~~~~~~~

:doc:`index` :ref:`glossary-HTTP` Port can be connected locally.

.. _monitor-tomcat_command_port:

tomcat_command_port
~~~~~~~~~~~~~~~~~~~

The :ref:`glossary-TCP`/IP port on which this server waits for a shutdown
command can be connected locally. Consult
http://tomcat.apache.org/tomcat-6.0-doc/config/server.html#Common_Attributes
for more detail.

.. warning::

  This port should listen only on :ref:`glossary-localhost`.

Optional
--------

.. _monitor-tomcat_port_ipv6:

tomcat_port_ipv6
~~~~~~~~~~~~~~~~

Same as :ref:`monitor-tomcat_port` but for :ref:`glossary-IPv6`.
