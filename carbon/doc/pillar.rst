Pillar
======

Mandatory
---------

Example::

  graphite:
    carbon:
      instances: 2
    retentions:
      default_1min_for_1_month:
        pattern: .*
        retentions: 60s:30d

graphite:carbon:instances
~~~~~~~~~~~~~~~~~~~~~~~~~

Number of instances to deploy, should <= numbers of CPU cores.

graphite:retentions
~~~~~~~~~~~~~~~~~~~

List of data retention rules, see the following for details:

http://graphite.readthedocs.org/en/latest/config-carbon.html#storage-schemas-conf

Optional
--------

Example::

  graphite:
    file-max: 65535
    carbon:
      replication: 1
      interface: 0.0.0.0
  shinken_pollers:
    - 192.168.1.1

graphite:file-max
~~~~~~~~~~~~~~~~~

Maximum of open files for the daemon.

Default: ``False``.

graphite:carbon:interface
~~~~~~~~~~~~~~~~~~~~~~~~~

Network interface to bind Carbon-relay daemon.

Default: ``0.0.0.0``.

graphite:carbon:replication
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Add redundancy of your data by replicating.

Every data point and relaying it to N caches (0 < N <= number of cache
instances).

Default: ``1``. Which is only one copy for each metric, thus no replication.
