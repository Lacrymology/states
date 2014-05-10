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

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- if ``postgresql:ssl`` is defined :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar`

Example::

  postgresql:
    listen_addresses: '*'
    replication:
      hot_standby: True
       master: 10.0.0.2
       standby:
         - 10.0.0.5
         - 10.0.0.6
    monitoring:
      password: mypassword

Optional
--------

postgresql:replication:master
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ip address of master server.

This key is mandatory if you are setting up a cluster.

encoding
~~~~~~~~

Encoding for using with postgresql.

Default: ``en_US.UTF-8``.

postgresql:listen_addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ip address for listening to.

Default: ``localhost``.

postgresql:shared_buffers
~~~~~~~~~~~~~~~~~~~~~~~~~

Size of shared buffers.

Default: ``24MB``.

postgresql:temp_buffers
~~~~~~~~~~~~~~~~~~~~~~~

Size of temp buffer.

Default: ``8MB``.

postgresql:destructive_absent
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Remove data directory when run absent SLS.

Default: ``False``.

postgresql:max_connections
~~~~~~~~~~~~~~~~~~~~~~~~~~

Default: ``100``.

postgresql:monitoring:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Password for monitoring user.

Default: ``auto-generate by salt``.

postgresql:listen_port
~~~~~~~~~~~~~~~~~~~~~~

Port to listen to.

Default: ``5432``.

postgresql:ssl
~~~~~~~~~~~~~~

Name of SSL key used for encrypted postgresql connection.

postgresql:log_slow_query
~~~~~~~~~~~~~~~~~~~~~~~~~

Onfig log for query statement.

-1 is disabled.

0 logs all statements.

> 0 logs only statements running at least this number of milliseconds.

Default: ``-1``.

postgresql:replication
~~~~~~~~~~~~~~~~~~~~~~

Keys prefix with 'postgresql:replication' are only used for cluster setup.

postgresql:replication:username
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Postgresql username used for replication.

Default: ``replication_agent``.

postgresql:replication:hot_standby
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run standby servers in hot standby mode.

Default: ``True``.

postgresql:replication:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Password for postgresql user that do replication.

Default: ``auto-generate by salt``.

postgresql:replication:standby
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of addresses of standby nodes in cluster.

Default: [].
