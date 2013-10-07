Pillar
======

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

Removed HOSTS_DENY entries that are older than this

denyhosts:whitelist
~~~~~~~~~~~~~~~~~~~

List white-list hosts

timedenyhosts:deny_threshold_invalid_user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Block each host after the number of failed login attempts has exceeded
this value for non-existent user account

denyhosts:deny_threshold_invalid_user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Block each host after the number of failed login attempts has exceeded this
value for user accounts that exist in /etc/passwd) except for the "root" user.

denyhosts:deny_threshold_root
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Block each host after the number of failed login attempts has exceeded
this value. for "root" user login attempts only

denyhosts:reset_valid
~~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that.
When exceeded will result in the failed count for this host to be reset to 0.
This value applies for all valid users (those within/ etc/passwd)
with the exception of root

denyhosts:reset_root
~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that.
When exceeded will result in the failed count for this host to be reset to 0.
This value applies for root user

denyhosts:reset_restricted
~~~~~~~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that,
when exceeded will result in the failed count for this host to be reset to 0.
This value applies to all login attempts to entries found in the
WORK_DIR/restricted-usernames file.

denyhosts:reset_invalid
~~~~~~~~~~~~~~~~~~~~~~~

Specifies the period of time between failed login attempts that,
when exceeded will result in the failed count for this host to be reset to 0.
This value applies to login attempts made to any invalid username
(those that do not  appear in /etc/passwd)

denyhosts:reset_on_success
~~~~~~~~~~~~~~~~~~~~~~~~~~

If this parameter is set to "yes" then the failed count for
the respective ip address will be reset to 0 if the login is successful

denyhosts:sync
~~~~~~~~~~~~~~

Enable Synchonization

denyhosts:sync:server
~~~~~~~~~~~~~~~~~~~~~

Server for synchonization

denyhosts:sync:interval
~~~~~~~~~~~~~~~~~~~~~~~

The interval of time to perform synchronizations

denyhosts:sync:upload
~~~~~~~~~~~~~~~~~~~~~

Allow your DenyHosts daemon to transmit denied hosts

denyhosts:sync:download
~~~~~~~~~~~~~~~~~~~~~~~

Allow your DenyHosts daemon to receive hosts that have been denied by others

denyhosts:sync:download_resiliency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The value specified for this option limits the downloaded data to
resiliency period or greater

Additional details on many of these pillar are documented in
``denyhosts/config.jinja2``.
