Monitor
=======

Mandatory
---------

shinken_arbiter_procs
~~~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _shinken_arbiter_port:

shinken_arbiter_port_remote
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check if the :doc:`/shinken/arbiter/doc/index` port can be reached from the
:doc:`/shinken/poller/doc/index`. It depends on :ref:`shinken_arbiter_port`.

In case it cannot be reached, first, make sure that the
:ref:`shinken_arbiter_port` is open, then check the firewall to see if there is
any rule block it.

Optional
--------

shinken_arbiter_port
~~~~~~~~~~~~~~~~~~~~

Check if the arbiter port is open.

If not, make sure that the configuration file contains no errors::

  /usr/local/shinken/bin/shinken-arbiter -v -c /etc/shinken/arbiter.conf

Then check the log file ``/var/log/upstart/shinken-arbiter.log`` for more
details.

This check is only enable if `Salt mine
<http://docs.saltstack.com/en/latest/topics/mine/index.html>`_ data for
monitoring is available.
