Pillar
======

Mandatory
---------

Example::

  nrpe:
    nsca:
      servers:
        - 192.168.1.1
        - 192.168.1.2
      password: Dba1dwjx

.. _pillar-nrpe-nsca-servers:

nrpe:nsca:servers
~~~~~~~~~~~~~~~~~

IP address of each node on :doc:`/shinken/doc/index`
`receiver <http://www.shinken-monitoring.org/wiki/nsca_daemon_module>`_ server.

.. _pillar-nrpe-nsca-password:

nrpe:nsca:password
~~~~~~~~~~~~~~~~~~

Password use to submit passive check to :ref:`shinken-receiver` (NSCA daemon in
this case).

Optional
--------

.. _pillar-nrpe-disk-warning_percentage:

nrpe:disk_warning_percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`check_disk <https://www.monitoring-plugins.org/doc/man/check_disk.html>`_ will
exit with WARNING status if less than PERCENT of disk space is free.

Default: ``20`` %.

.. _pillar-nrpe-max_proc:

nrpe:max_proc
~~~~~~~~~~~~~

How many processes can run on the system before it raise a warning.

Default: ``150`` processes.

nrpe:timeout
~~~~~~~~~~~~

This specifies the maximum number of seconds that the daemon will allow plugins
to finish executing before killing them off.

Default: ``60`` seconds.
