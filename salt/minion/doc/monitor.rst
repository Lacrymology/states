Monitor
=======

Mandatory
---------

.. _monitor-salt_minion_procs:

salt_minion_procs
~~~~~~~~~~~~~~~~~

Salt Minion Daemon listens to commands from a :doc:`/salt/master/doc/index`
and perform the requested tasks. Generally, :doc:`/salt/minion/doc/index` s
are servers which are to be controlled using :doc:`/salt/doc/index`.

.. include:: /nrpe/doc/check_procs.inc

salt_minion_pillar_render
~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/salt/minion/doc/index` rendered its
`pillar <http://docs.saltstack.com/en/latest/topics/tutorials/pillar.html>`_
successfully.

This check will fail if rendering pillar encounters any error. It is necessary
to change pillar data to fix what was wrong.

Optional
--------

Only use if :ref:`pillar-salt-highstate` is turned on.

salt_minion_last_success
~~~~~~~~~~~~~~~~~~~~~~~~

Last success ``state.highstate`` call is more recently than configured
threshold.

This check failure indicates the server was not successfully run
``state.highstate`` and is outdated to latest salt formulas configured for it.
It probably caused by a state failure (bad pillar data, bad formula, ...).
User needs to check the log to indicate exact problem.
