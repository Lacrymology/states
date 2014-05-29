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

Optional
--------

Example::

  denyhosts:
    purge: 1d
    deny_threshold_invalid_user: 5
    deny_threshold_valid_user: 10
    deny_threshold_root: 1
    reset_valid: 5d
    reset_root: 5d
    reset_restricted: 25d
    reset_invalid: 10d
    reset_on_success: no
    sync:
      server: 192.168.1.1
      interval: 1h
      upload: yes
      download: yes
      download_threshold: 3
      download_resiliency: 5h
    whitelist:
      - 127.0.0.1

denyhosts:purge
~~~~~~~~~~~~~~~

Removed denied hosts entries that are older than this.

Default: ``1d``.

denyhosts:whitelist
~~~~~~~~~~~~~~~~~~~

List white-list hosts.

Default: empty list (``[]``).

timedenyhosts:deny_threshold_invalid_user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Block each host after the number of failed login attempts has exceeded
this value for non-existent user account.

Default: ``5``.

denyhosts:deny_threshold_valid_user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Block each host after the number of failed login attempts has exceeded this
value for user accounts that exist in ``/etc/passwd``) except for the ``root``
user.

Default: ``10``.

denyhosts:deny_threshold_root
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Block each host after the number of failed login attempts has exceeded
this value. for ``root`` user login attempts only.

Default: ``1``.

denyhosts:reset_valid
~~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that.
When exceeded will result in the failed count for this host to be reset to
``0``.
This value applies for all valid users (those within ``/etc/passwd``)
with the exception of ``root``.

Default: ``5d``.

denyhosts:reset_root
~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that.
When exceeded will result in the failed count for this host to be reset to
``0``.
This value applies for ``root`` user.

Default: ``5d``.

denyhosts:reset_restricted
~~~~~~~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that,
when exceeded will result in the failed count for this host to be reset to
``0``.
This value applies to all login attempts to entries found in the
``/var/lib/denyhosts/restricted-usernames`` file.

Default: ``25d``.

denyhosts:reset_invalid
~~~~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that,
when exceeded will result in the failed count for this host to be reset to
``0``.
This value applies to login attempts made to any invalid username
(those that do not  appear in ``/etc/passwd``).

Default: ``10d``.

denyhosts:reset_on_success
~~~~~~~~~~~~~~~~~~~~~~~~~~

If this parameter is set to ``yes`` then the failed count for
the respective ip address will be reset to ``0`` if the login is successful.

Default: ``no``.

denyhosts:sync
~~~~~~~~~~~~~~

Enable Synchonization.

Default: ``False``.

denyhosts:sync:server
~~~~~~~~~~~~~~~~~~~~~

Server for synchonization.

denyhosts:sync:interval
~~~~~~~~~~~~~~~~~~~~~~~

The interval of time to perform synchronizations.

Default: ``1h``.

denyhosts:sync:upload
~~~~~~~~~~~~~~~~~~~~~

Allow your DenyHosts daemon to transmit denied hosts.

Default: ``yes``.

denyhosts:sync:download
~~~~~~~~~~~~~~~~~~~~~~~

Allow your DenyHosts daemon to receive hosts that have been denied by others.

Default: ``yes``.

denyhosts:sync:download_threshold
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If ``denyhosts:sync:download`` is enabled this parameter filters the returned
hosts to those that have been blocked this many times by others. That is, if set
to ``1``, then if a single DenyHosts server has denied an ip address then you
will receive the denied host.

Default: ``3``.

denyhosts:sync:download_resiliency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The value specified for this option limits the downloaded data to
resiliency period or greater.

Additional details on many of these pillar are documented in
:download:`config <../config.jinja2>`.

Default: ``5h``.
