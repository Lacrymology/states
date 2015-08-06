Monitor
=======

Terminology:

- `Plaintext port <http://graphite.readthedocs.org/en/latest/carbon-daemons.html
  #carbon-relay-py>`_
- `Pickle port <http://graphite.readthedocs.org/en/latest/feeding-carbon.html
  #the-pickle-protocol>`_
- Cache Query port: port that carbon-cache daemon listen to, allows
  :doc:`/graphite/doc/index` webapp to query for data that has not
  yet been persisted. See `graphite config setting
  <http://graphite.readthedocs.org/en/latest/config-local-settings.html?
  highlight=query#cluster-configuration>`_ for more details.

Mandatory
---------

.. _monitor-carbon_cache_instance_procs:

carbon_cache_{{ instance }}_procs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

carbon-cache_ daemon
process is the :ref:`glossary-daemon` which accepts metrics sent from multiple
sources/protocols and writes them to disk. Number of this daemons is
the value defined in :ref:`pillar-carbon-cache_daemons`.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-carbon_cache_instance_plaintext_port:

carbon_cache_{{ instance }}_plaintext_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

carbon-cache_ {{ instance }} plaintext port is listening on localhost
(``127.0.0.1``).

.. _monitor-carbon_cache_instance_pickle_port:

carbon_cache_{{ instance }}_pickle_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

carbon-cache_ {{ instance }} pickle port is listening on localhost
(``127.0.0.1``).

.. _monitor-carbon_cache_instance_cache_query_port:

carbon_cache_{{ instance }}_cache_query_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

carbon-cache_ {{ instance }} query port is listening on localhost
(``127.0.0.1``).

.. _monitor-carbon_cache_procs:

carbon_cache_procs
~~~~~~~~~~~~~~~~~~

Number of `carbon-cache` processes equal to value set in
:ref:`pillar-carbon-cache_daemons`.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-carbon_relay_procs:

carbon_relay_procs
~~~~~~~~~~~~~~~~~~

carbon-relay_ daemon
process serves two distinct purposes: replication and sharding.
This formula support only one instance of carbon-relay_ daemon, which will
relay all incoming metrics to multiple backend carbon-cache_ daemons.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-carbon_plaintext_port_remote:

carbon_plaintext_port_remote
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

carbon-relay_ PlainText port is listening and can be reached from outside.

.. _monitor-carbon_pickle_port_remote:

carbon_pickle_port_remote
~~~~~~~~~~~~~~~~~~~~~~~~~

carbon-relay_ daemon Pickle port is listening and can be reached from outside.

.. _monitor-carbon_plaintext_port:

.. |deployment| replace:: carbon

.. include:: /backup/doc/monitor_procs.inc

.. include:: /backup/doc/monitor.inc

.. _carbon-relay: http://graphite.readthedocs.org/en/latest/carbon-daemons.html#carbon-relay-py

.. _carbon-cache: http://graphite.readthedocs.org/en/latest/carbon-daemons.html#carbon-cache-py

Optional
--------

Following checks are only enable if :ref:`pillar-carbon-interface` is set to
``::``, ``0.0.0.0`` or ``127.0.0.1``.

carbon_plaintext_port
~~~~~~~~~~~~~~~~~~~~~

carbon-relay_ PlainText Port is listening on localhost (``127.0.0.1``).

.. _monitor-carbon_pickle_port:

carbon_pickle_port
~~~~~~~~~~~~~~~~~~

carbon-relay_ Pickle Port is listening on localhost (``127.0.0.1``).

Following checks are only enable if :ref:`pillar-carbon-interface` is set to
``::`` or ``::1``.

.. _monitor-carbon_plaintext_port_ipv6:

carbon_plaintext_port_ipv6
~~~~~~~~~~~~~~~~~~~~~~~~~~

carbon-relay_ PlainText Port is listening on ip6-localhost (``::1``).

.. _monitor-carbon_pickle_port_ipv6:

carbon_pickle_port_ipv6
~~~~~~~~~~~~~~~~~~~~~~~

carbon-relay_ Pickle Port is listening on ip6-localhost usi (``::1``).
