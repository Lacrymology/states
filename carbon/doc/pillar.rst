.. Copyright (c) 2013, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

.. include:: /doc/include/add_pillar.inc

- :doc:`/pip/doc/index` :doc:`/pip/doc/pillar`

Mandatory
---------

Example::

  graphite:
    carbon:
      instances: 2
    retentions:
      - pattern: .*
        retentions: 60s:30d

graphite:carbon:instances
~~~~~~~~~~~~~~~~~~~~~~~~~

Number of instances to deploy, should <= numbers of
`CPU cores <https://en.wikipedia.org/wiki/Multi-core_processor>`__.

graphite:retentions
~~~~~~~~~~~~~~~~~~~

The retentions policies of metrics stored on disk. Frequency should >= 60s
as metric collectors usually configured to send data each 60 seconds. Setting
frequency < 60s may cause discontinuous line in Graphite graph.
Changing this pillar key will change retentions policy of new ``.wsp`` files,
it will not affect existed ``.wsp`` files, use ``whisper-resize.py``
to convert existed files.

Example, below command find all ``.wsp`` files and apply new retentions policy
``60s:1d,300s:7d,15m:30d,30m:90d``, run it as ``root``::

  su graphite -s /bin/bash -c 'find /var/lib/graphite/whisper/ -name '*.wsp' -type f -exec /usr/local/graphite/bin/whisper-resize.py {} 60s:1d 300s:7d 15m:30d 30m:90d \;'

Notice that it will all ``.wsp`` files in ``/var/lib/graphite/whisper``,
it may change files which use other retention policy.

List of data retention rules, see the
`Graphite doc <http://graphite.readthedocs.org/en/latest/config-carbon.html#storage-schemas-conf>`__
for details of syntax.

Optional
--------

Example::

  graphite:
    file-max: 65535
    carbon:
      replication: 1
      interface: 0.0.0.0
      max_creates_per_minute: inf
      max_updates_per_second: 500

graphite:file-max
~~~~~~~~~~~~~~~~~

Maximum of open files for the daemon.

Default: ``False``.

graphite:carbon:interface
~~~~~~~~~~~~~~~~~~~~~~~~~

Network interface to bind Carbon-relay daemon.

Default: ``0.0.0.0``.

graphite:carbon:max_creates_per_minute
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Softly limits the number of whisper files that get created each minute.
Setting this value low (like at ``50``) is a good way to ensure your graphite
system will not be adversely impacted when a bunch of new metrics are
sent to it. The trade off is that it will take much longer for those metrics'
database files to all get created and thus longer until the data becomes usable.
Setting this value high (like ``inf`` for infinity) will cause graphite to create
the files quickly but at the risk of slowing I/O down considerably for a while.

Default: ``inf``. No limit.

graphite:carbon:max_updates_per_second
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Limits the number of whisper update_many() calls per second, which effectively
means the number of write requests sent to the disk. This is intended to
prevent over-utilizing the disk and thus starving the rest of the system.
When the rate of required updates exceeds this, then carbon's caching will
take effect and increase the overall throughput accordingly.

Default: ``500``.

graphite:carbon:replication
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Add redundancy of your data by replicating.

Every data point and relaying it to N caches (0 < N <= number of cache
instances).

Default: ``1``. Which is only one copy for each metric, thus no replication.

graphite:carbon:filter:type
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Put in place blacklisting or metrics or whitelisting.

Available values: ``black`` or ``white``.

Default: ``None``. Unused.

graphite:carbon:filter:rules
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of regular expressions of black or white listed metrics.

Used only if ``graphite:carbon:filter:type`` is turned on.

Default: ``[]``. Empty list.
