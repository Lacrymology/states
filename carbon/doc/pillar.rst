:Copyrights: Copyright (c) 2013, Bruno Clermont

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.

             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:Authors: - Bruno Clermont

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
