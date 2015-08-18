Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/pip/doc/index` :doc:`/pip/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/ssh/client/doc/index` :doc:`/ssh/client/doc/pillar`

Optional
--------

Example::

    salt_master:
      gitfs_remotes:
        - git@git.example.com:common.git
        - git@git.example.com:states.git
        - subdir git@git.example.com:anotherstates.git
      workers: 1
      pillar:
        branch: develop
        remote: git@git.example.com:dev/pillars.git

.. _pillar-salt_master-gitfs_remotes:

salt_master:gitfs_remotes
~~~~~~~~~~~~~~~~~~~~~~~~~

.. copied from https://github.com/saltstack/salt/blob/2014.1/conf/master#L385

`Git fileserver <http://docs.saltstack.com/en/latest/topics/tutorials/gitfs.html>`_
backend configuration.
When using the fileserver backend at least one :doc:`/git/doc/index` remote
needs to be defined.

The user ``root`` running the :doc:`/salt/master/doc/index` need read
access to the :doc:`/git/doc/index` repositories.
The pillar key :ref:`pillar-ssh-keys` is probably
required  and it's key authorized to read the
repository. And the server :ref:`pillar-ssh-hosts` defined too.

Look in :doc:`/ssh/client/doc/index` for more details, more importantly the
following pillar keys are probably required:

If the :doc:`index` act also as the :doc:`/git/server/doc/index`, look for
:doc:`/git/server/doc/pillar` exact pillars keys details.

.. note::

  To use a subdir from the checkout of an repo as a file root, specify the
  dirname before the git link

Default: ``[]``.

.. warning::

  Make sure there is no branch names under a sub-directory namespace
  (with a ``/`` into it. This cause Salt 2014.1.x to fail.

.. _pillar-salt_master-git_pull_frequency:

salt_master:git_pull_frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

How often does repositories in :ref:`pillar-salt_master-gitfs_remotes` be
fetched (in minutes, only allows value from ``0`` to ``59``).

Default: ``5`` minutes.

.. _pillar-salt_master-pillar-remote:

salt_master:pillar:remote
~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/git/doc/index` remote address to use for pillar source repository.

Default: ``False`` - not used.

.. warning::

  To work it also need :ref:`pillar-salt_master-pillar-branch` defined.

.. _pillar-salt_master-pillar-branch:

salt_master:pillar:branch
~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/git/doc/index` branch to checkout and use as a pillar source repository.

Default: ``False`` - not used.

.. warning::

  To work it also need :ref:`pillar-salt_master-pillar-remote` defined.

.. _pillar-salt_master-loop_interval:

salt_master:loop_interval
~~~~~~~~~~~~~~~~~~~~~~~~~

.. https://github.com/saltstack/salt/blob/2014.1/conf/master#L80

The loop_interval option controls the seconds for the master's maintinance
process check cycle. This process updates file server backends, cleans the
job cache and executes the scheduler.

Default: ``60``.

.. _pillar-salt_master-keep_jobs_hours:

salt_master:keep_jobs_hours
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. https://github.com/saltstack/salt/blob/2014.1/conf/master#L73

Set the number of hours to keep old job information in the job cache

Default: ``24``.

.. _pillar-salt_master-reactor:

salt_master:reactor
~~~~~~~~~~~~~~~~~~~

Automatically process most of the common events, such as run ``state.highstate``
on newly created minion with :doc:`/salt/cloud/doc/index`.

Default: turn it off (``False``).

salt_master:xmpp
~~~~~~~~~~~~~~~~

Enable :doc:`index` :ref:`glossary-xmpp` integration.

Example::

  salt_master:
    xmpp:
      jid: joe@chat.example.com
      password: password
      recipients:
        - recipient1
        - recipient2
      rooms:
        - room1@conference.chat.example.com
      events:
        - highstate

Format:

  jid
      `Jabber Identifier <http://xmpp.org/extensions/xep-0029.html>`_
  password
      password of :ref:`glossary-xmpp` account
  recipients
      list of recipients will receive :doc:`index` notifications via private
      message.
  rooms
      list of chat rooms will receive :doc:`index` notifications via multi-user
      chat (MUC).
  events:
      list of events to fire notification, currently only ``highstate`` is
      supported

Default: turn off notify by :ref:`glossary-xmpp` (``{}``).

.. _pillar-salt_master-workers:

salt_master:workers
~~~~~~~~~~~~~~~~~~~

Numbers of workers.

Default: uses number of CPU cores (``None``).

Conditional
-----------

.. _pillar-salt_master-highstate_days:

salt_master:highstate_days
~~~~~~~~~~~~~~~~~~~~~~~~~~

A list of days :doc:`index` will run highstate on all VMs which has
:ref:`pillar-salt-highstate` set to ``True``.

The day is in the number format (same as the :doc:`/cron/doc/index`): 0 to 6
are Sunday to Saturday.
