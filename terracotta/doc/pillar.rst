Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Optional
--------

.. _pillar-terracotta-environment:

terracotta:environment
~~~~~~~~~~~~~~~~~~~~~~

.. Copied from
   http://terracotta.org/documentation/3.7.4/bigmemorymax/
   terracotta-server-array/config-reference#
   tctc-configsystemconfiguration-model

The configuration-model element is for informational purposes. The two
configuration-model options are 'development' and 'production'. These values
have no effect on the functioning of Terracotta servers or clients, but instead
allow you to designate the intended use of a configuration file using one of
two recommended modes.

In development, you may want each client might have its own configuration,
independent of the server or any other client. This approach is useful for
development, but should not be used in production as it can result in
unpredictable behavior should conflicts arise. To note that a configuration
file is intended for direct use by a client, set the configuration-model to
'development'.

In production, each client should obtain its configuration from a Terracotta
server instance. To note that a configuration file is intended be be fetched
from a server, set the configuration-model to 'production'.

Default: ``production``.

.. _pillar-terracotta-java_ms:

terracotta:java_ms
~~~~~~~~~~~~~~~~~~

Set initial `Java heap size
<https://docs.oracle.com/cd/E13222_01/wls/docs81/perform/
JVMTuning.html#1131866>`_ (-Xms).

Format: <size>[g|G|m|M|k|K].

Default: 512 megabytes (``512m``).

.. _pillar-terracotta-java_mx:

terracotta:java_mx
~~~~~~~~~~~~~~~~~~

Set maximum Java heap size (-Xmx).

Format: <size>[g|G|m|M|k|K].

Default: 512 megabytes (``512m``).
