Monitor
=======

Mandatory
---------

.. _monitor-nsca_passive_procs:

nsca_passive_procs
~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-free_disks_space:

free_disks_space
~~~~~~~~~~~~~~~~

Warning if total free disk space is less than 20%.

.. _monitor-total_procs:

total_procs
~~~~~~~~~~~

Check the total number of processes.

Warning if it is greater than :ref:`pillar-nrpe-max_proc`.

.. _monitor-zombie_procs:

zombie_procs
~~~~~~~~~~~~

Check if there is any `zombie process
<http://en.wikipedia.org/wiki/Zombie_process>`_.

.. _monitor-nrpe_procs:

nrpe_procs
~~~~~~~~~~

There should always have at least 1 :doc:`index` daemon process which has
PPID=1. The check does not check for singularity of :doc:`index` daemon
process but make sure its existence.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-nrpe_check_procs:

nrpe_check_procs
~~~~~~~~~~~~~~~~

Check number of running :doc:`index` checks.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-nrpe_hang_check_procs:

nrpe_hang_check_procs
~~~~~~~~~~~~~~~~~~~~~

Check number of long running :doc:`index` check processes,
which probably are hanging processes.
This check base on ELAPSE time of process, and with state ``S``.
The main :doc:`index` process has state ``Ss``.

.. _monitor-logged_users:

logged_users
~~~~~~~~~~~~

Warning if the number of users currently logged in is greater than 15.

.. _monitor-loopback_interface:

loopback_interface
~~~~~~~~~~~~~~~~~~

Check if the loopback interface is up.

.. _monitor-loopback_interface_ipv6:

loopback_interface_ipv6
~~~~~~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-loopback_interface` but for :ref:`glossary-IPv6`.

.. _monitor-oom_messages:

oom_messages
~~~~~~~~~~~~

Check if there is any `Out Of Memory
<http://en.wikipedia.org/wiki/Out_of_memory>`_ message in the
:doc:`/rsyslog/doc/index`.

.. _monitor-free_memory:

free_memory
~~~~~~~~~~~

Warning if the free memory (parsed from ``/proc/meminfo``) is less than 10%.

.. _monitor-load_average:

load_average
~~~~~~~~~~~~

The system `load averages
<http://blog.scoutapp.com/articles/2009/07/31/understanding-load-averages>`_
for the past 1, 5, and 15 minutes.

.. _monitor-nrpe-remote-port:

nrpe-remote-port
~~~~~~~~~~~~~~~~

Check if port :ref:`glossary-TCP` ``5666`` can be reached from the outside.

Optional
--------

.. _monitor-free_swap_space:

free_swap_space
~~~~~~~~~~~~~~~

Warning if the free swap less than ``30%``.

Only perform this check if the swap partition/file exists and the minion is not
running on `OpenVZ <http://openvz.org/Main_Page>`_.
