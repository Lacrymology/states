Monitor
=======

Mandatory
---------

tomcat_procs
------------

:doc:`/tomcat/doc/index/` daemon run as web server and servlet container
for :doc:`/java/doc/index` application.

.. include:: /nrpe/doc/check_procs.inc

tomcat_port_remote
------------------

:doc:`/tomcat/doc/index/` HTTP Port is reachable from outside.

tomcat_port
-----------

:doc:`/tomcat/doc/index/` HTTP Port can be connected locally.

tomcat_command_port
-------------------

The TCP/IP port on which this server waits for a shutdown command can be
connected locally. Consult http://tomcat.apache.org/tomcat-6.0-doc/config/server.html#Common_Attributes
for more detail.

.. warning::

  This port should listen only on `localhost <http://en.wikipedia.org/wiki/Localhost>`__.
