Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/pip/doc/index` :doc:`/pip/doc/pillar`

Mandatory
---------

Example::

  carbon:
    cache_daemons: 2
    max_cache_size: 'inf'
    retentions:
      - pattern: .*
        retentions: 60s:30d

.. _pillar-carbon-cache_daemons:

carbon:cache_daemons
~~~~~~~~~~~~~~~~~~~~

Number of carbon-cache_ daemons to deploy, should <= numbers of
`CPU cores <https://en.wikipedia.org/wiki/Multi-core_processor>`_.

Optional
--------

Example::

  carbon:
    files_max: 65535
    replication: 1
    interface: '::'
    max_creates_per_minute: inf
    max_updates_per_second: 500


.. _pillar-carbon-files_max:

carbon:files_max
~~~~~~~~~~~~~~~~

Maximum of open files allowed for each carbon daemons (relay and cache).

Default: a sensible high value, as carbon daemons often
need to open many files (``16384``).

.. _pillar-carbon-interface:

carbon:interface
~~~~~~~~~~~~~~~~

IP address to bind carbon-relay_ daemon.

Default: binds to all available IP addresses of all interfaces (``'::'``).

.. _pillar-carbon-max_creates_per_minute:

carbon:max_creates_per_minute
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Softly limits the number of whisper files that get created each minute.
Setting this value low (like at ``50``) is a good way to ensure your graphite
system will not be adversely impacted when a bunch of new metrics are
sent to it. The trade off is that it will take much longer for those metrics'
database files to all get created and thus longer until the data becomes
usable.  Setting this value high (like ``inf`` for infinity) will cause
:doc:`/graphite/doc/index` to create the files quickly but at the risk of
slowing I/O down considerably for a while.

Default: No limit (``inf``).

.. _pillar-carbon-max_updates_per_second:

carbon:max_updates_per_second
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Limits the number of whisper update_many() calls per second, which effectively
means the number of write requests sent to the disk. This is intended to
prevent over-utilizing the disk and thus starving the rest of the system.
When the rate of required updates exceeds this, then carbon's caching will
take effect and increase the overall throughput accordingly.

Default: :doc:`index` default value ``500``.

.. _pillar-carbon-replication:

carbon:replication
~~~~~~~~~~~~~~~~~~

Add redundancy of data by replicating.

Every data point and relaying it to N carbon-cache_ daemons
(0 < N <= number of Carbon-cache daemon).

Default: ``1``. Which is only one copy for each metric, thus no replication.

.. _pillar-carbon-filter-type:

carbon:filter:type
~~~~~~~~~~~~~~~~~~

Put in place blacklisting or metrics or whitelisting.

Available values: ``black`` or ``white``.

Default: Unused (``None``).

.. _pillar-carbon-max_cache_size:

carbon:max_cache_size
~~~~~~~~~~~~~~~~~~~~~

Limit the size of the :doc:`index` cache to avoid swapping or becoming CPU
bound.  Size of :doc:`index` cache = maximum number of datapoints it can hold.
Consult http://graphite.readthedocs.org/en/latest/terminology.html#term-series
for more detail on datapoints.

Default: No limit (``inf``).

.. _pillar-carbon-retentions:

carbon:retentions
~~~~~~~~~~~~~~~~~

The retentions policies of metrics stored on disk. Frequency should >= 60
seconds as metric collectors usually configured to send data each 60 seconds.
Setting frequency < 60 seconds may cause discontinuous line in
:doc:`/graphite/doc/index` graph.
Changing this pillar key will change retentions policy of new ``.wsp`` files,
it will not affect existed ``.wsp`` files, use ``whisper-resize.py``
to convert existed files.

Example, below command find all ``.wsp`` files and apply new retentions policy
``60s:1d,300s:7d,15m:30d,30m:90d``, run it as ``root``::

  su graphite -s /bin/bash -c 'find /var/lib/graphite/whisper/ -name '*.wsp' -type f -exec /usr/local/graphite/bin/whisper-resize.py {} 60s:1d 300s:7d 15m:30d 30m:90d \;'

Notice that it will all ``.wsp`` files in ``/var/lib/graphite/whisper``,
it may change files which use other retention policy.

List of data retention rules, see the
`Graphite doc <http://graphite.readthedocs.org/en/latest/config-carbon.html#storage-schemas-conf>`_
for details of syntax.

Default: all metrics will be stored each 60 seconds,
in 30 days (``[{'pattern' : '.*', 'retentions': '60s:30d'}]``).

Conditional
-----------

.. _pillar-carbon-filter-rules:

carbon:filter:rules
~~~~~~~~~~~~~~~~~~~

List of regular expressions of black or white listed metrics.

Used only if :ref:`pillar-carbon-filter-type` is turned on.

Default: no filter rule (``[]``).

.. _carbon-relay: http://graphite.readthedocs.org/en/latest/carbon-daemons.html#carbon-relay-py

.. _carbon-cache: http://graphite.readthedocs.org/en/latest/carbon-daemons.html#carbon-cache-py
