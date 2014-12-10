Pillar
======

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
    reset_on_success: False
    sync:
      server: 192.168.1.1
      interval: 1h
      upload: True
      download: True
      download_threshold: 3
      download_resiliency: 5h
    whitelist:
      - 127.0.0.1

.. _pillar-denyhosts-purge:

denyhosts:purge
~~~~~~~~~~~~~~~

Removed denied hosts entries that are older than this.

Default: 1 day (``1d``).

.. _pillar-denyhosts-whitelist:

denyhosts:whitelist
~~~~~~~~~~~~~~~~~~~

List white-list hosts.

Default: Unused (empty list ``[]``).

.. _pillar-denyhosts-deny_threshold_invalid_user:

denyhosts:deny_threshold_invalid_user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Block each host after the number of failed login attempts has exceeded
this value for non-existent user account.

Default: ``5`` attempts.

.. _pillar-denyhosts-deny_threshold_valid_user:

denyhosts:deny_threshold_valid_user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Block each host after the number of failed login attempts has exceeded this
value for user accounts that exist in ``/etc/passwd``) except for the ``root``
user.

Default: ``10`` attempts.

.. _pillar-denyhosts-deny_threshold_root:

denyhosts:deny_threshold_root
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Block each host after the number of failed login attempts has exceeded
this value. for ``root`` user login attempts only.

Default: ``1`` attempt.

.. _pillar-denyhosts-reset_valid:

denyhosts:reset_valid
~~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that.
When exceeded will result in the failed count for this host to be reset to
``0``.
This value applies for all valid users (those within ``/etc/passwd``)
with the exception of ``root``.

Default: Reset after 5 days (``5d``).

.. _pillar-denyhosts-reset_root:

denyhosts:reset_root
~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that.
When exceeded will result in the failed count for this host to be reset to
``0``.
This value applies for ``root`` user.

Default: Reset after 5 days (``5d``).

.. _pillar-denyhosts-reset_restricted:

denyhosts:reset_restricted
~~~~~~~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that,
when exceeded will result in the failed count for this host to be reset to
``0``.
This value applies to all login attempts to entries found in the
``/var/lib/denyhosts/restricted-usernames`` file.

Default: Reset after 25 days (``25d``).

.. _pillar-denyhosts-reset_invalid:

denyhosts:reset_invalid
~~~~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that,
when exceeded will result in the failed count for this host to be reset to
``0``.
This value applies to login attempts made to any invalid username
(those that do not  appear in ``/etc/passwd``).

Default: Reset after 10 days (``10d``).

.. _pillar-denyhosts-reset_on_success:

denyhosts:reset_on_success
~~~~~~~~~~~~~~~~~~~~~~~~~~

If this parameter is set to ``True`` then the failed count for
the respective ip address will be reset to ``0`` if the login is successful.

Default: Not reset (``False``).

.. _pillar-denyhosts-sync:

denyhosts:sync
~~~~~~~~~~~~~~

Enable `synchronization mode <http://denyhosts.sourceforge.net/faq.html#4_0>`_.

Default: Disabled (``False``).

Conditional
-----------

.. _pillar-denyhosts-sync-server:

denyhosts:sync:server
~~~~~~~~~~~~~~~~~~~~~

Server for `synchonization <http://denyhosts.sourceforge.net/faq.html#4_5>`_.

Default: ``http://xmlrpc.denyhosts.net:9911``

.. _pillar-denyhosts-sync-interval:

denyhosts:sync:interval
~~~~~~~~~~~~~~~~~~~~~~~

The interval of time to perform `synchronizations <http://denyhosts.sourceforge.net/faq.html#4_0>`_.

Default: 1 hour (``1h``).

.. _pillar-denyhosts-sync-upload:

denyhosts:sync:upload
~~~~~~~~~~~~~~~~~~~~~

Allow DenyHosts daemon to upload data to ``denyhosts.net`` or not.

Default: Upload data (``True``).

.. _pillar-denyhosts-sync-download:

denyhosts:sync:download
~~~~~~~~~~~~~~~~~~~~~~~

Allow your DenyHosts daemon to receive hosts that have been denied by others.

Default: ``True``.

.. _pillar-denyhosts-sync-download_threshold:

denyhosts:sync:download_threshold
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If ``denyhosts:sync:download`` is enabled this parameter filters the returned
hosts to those that have been blocked this many times by others. That is, if set
to ``1``, then if a single DenyHosts server has denied an ip address then you
will receive the denied host.

Default: Blocked by ``3`` other DenyHosts daemons will be downloaded.

.. _pillar-denyhosts-sync-download_resiliency:

denyhosts:sync:download_resiliency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The value specified for this option limits the downloaded data to
resiliency period or greater.

Additional details on many of these pillar are documented in
:download:`config <../config.jinja2>`.

Default: ``5h``.
