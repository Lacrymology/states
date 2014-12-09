Metrics
=======

.. _firewall_conn_track:

Linux Kernel Connection Table
-----------------------------

Linux kernel :doc:`/firewall/doc/index` provides an "API" to consult it.

`connection tracking <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Security_Guide/sect-Security_Guide-Firewalls-IPTables_and_Connection_Tracking.html>`_


The connection tracking table is turn into the following metrics.

ConnTrackCollector
------------------

conntrack.ip_conntrack_count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Number of entries in the :ref:`firewall_conn_track` table at the moment.

conntrack.ip_conntrack_max
~~~~~~~~~~~~~~~~~~~~~~~~~~

The maximum number of allowed :ref:`firewall_conn_track` entries.
