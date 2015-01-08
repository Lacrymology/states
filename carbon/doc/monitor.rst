Monitor
=======

Terminology:

- `Plaintext port <http://graphite.readthedocs.org/en/latest/carbon-daemons.html#carbon-relay-py>`_
- `Pickle port <http://graphite.readthedocs.org/en/latest/feeding-carbon.html#the-pickle-protocol>`_

.. TODO explains Cache Query port.

Mandatory
---------

.. _monitor-carbon_cache_instance_procs:

carbon_cache_{{ instance }}_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Carbon-cache daemon <http://graphite.readthedocs.org/en/latest/carbon-daemons.html#carbon-cache-py>`_
process is the daemon which accepts metrics sent from multiple
sources/protocols and writes them to disk. Number of this daemons is
the value defined in :ref:`pillar-carbon-cache_daemons`.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-carbon_cache_instance_plaintext_port:

carbon_cache_{{ instance }}_plaintext_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Carbon Cache {{ instance }} plaintext port is listening on localhost
(``127.0.0.1``).

.. _monitor-carbon_cache_instance_pickle_port:

carbon_cache_{{ instance }}_pickle_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Carbon Cache {{ instance }} pickle port is listening on localhost
(``127.0.0.1``).

.. _monitor-carbon_cache_instance_cache_query_port:

carbon_cache_{{ instance }}_cache_query_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Carbon Cache {{ instance }} query port is listening on localhost
(``127.0.0.1``).

.. _monitor-carbon_cache_procs:

carbon_cache_procs
~~~~~~~~~~~~~~~~~~

.. TODO: use include?

Number of `carbon-cache` processes equal to value set in
:ref:`pillar-carbon-cache_daemons`.

Alert if missing any process (such as if daemon died) or there are more than
expected processes - maybe a :doc:`/carbon/doc/index` formula bug or someone ran
those daemon manually.

.. _monitor-carbon_relay_procs:

carbon_relay_procs
~~~~~~~~~~~~~~~~~~

`Carbon relay daemon <http://graphite.readthedocs.org/en/latest/carbon-daemons.html#carbon-relay-py>`_
process serves two distinct purposes: replication and sharding.
This formula support only one instance of `carbon-relay` daemon, which will
relay all incoming metrics to multiple backend `carbon-cache` daemons.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-carbon_plaintext_port_remote:

carbon_plaintext_port_remote
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. TODO: link to carbon relay doc

Carbon-relay PlainText port is listening and can be reached from outside.

.. _monitor-carbon_pickle_port_remote:

carbon_pickle_port_remote
~~~~~~~~~~~~~~~~~~~~~~~~~

.. TODO: link to carbon relay doc

Carbon-relay daemon Pickle port is listening and can be reached from outside.

.. _monitor-carbon_plaintext_port:

carbon_plaintext_port
~~~~~~~~~~~~~~~~~~~~~

Carbon-relay PlainText Port is listening on localhost (``127.0.0.1``).

.. _monitor-carbon_pickle_port:

carbon_pickle_port
~~~~~~~~~~~~~~~~~~

Carbon-relay Pickle Port is listening on localhost (``127.0.0.1``).

.. |deployment| replace:: carbon

.. include:: /backup/doc/monitor_procs.inc

.. include:: /backup/doc/monitor.inc
