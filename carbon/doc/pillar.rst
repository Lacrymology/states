Pillar
======

Mandatory 
---------

message_do_not_modify: Warning message to not modify file.

graphite:
  carbon:
    instances: 2
  retentions:
    default_1min_for_1_month:
      pattern: .*
      retentions: 60s:30d

graphite:carbon:instances: number of instances to deploy, should <= numbers of CPU cores
~~~~~~~~~~~~~~~~~~~~~~~~~

graphite:retentions: list of data retention rules, see the following for details:
~~~~~~~~~~~~~~~~~~~

    http://graphite.readthedocs.org/en/latest/config-carbon.html#storage-schemas-conf

Optional 
--------

graphite:
  file-max: 65535
  carbon:
    replication: 1
    interface: 0.0.0.0
shinken_pollers:
  - 192.168.1.1

graphite:file-max: maximum of open files for the daemon. Default: not used.
~~~~~~~~~~~~~~~~~

graphite:carbon:interface: Network interface to bind Carbon-relay daemon.
~~~~~~~~~~~~~~~~~~~~~~~~~

    Default: 0.0.0.0.

graphite:carbon:replication: add redundancy of your data by replicating
~~~~~~~~~~~~~~~~~~~~~~~~~~~

    every data point and relaying it to N caches (0 < N <= number of cache instances).
    Default: 1 (Mean you have only one copy for each metric = No replication)
shinken_pollers: IP address of monitoring poller that check this server.
    Default: not used.
