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
      workers: 1
      pillar:
        branch: develop
        remote: git@git.example.com:dev/pillars.git

salt_master:gitfs_remotes
~~~~~~~~~~~~~~~~~~~~~~~~~

.. copied from https://github.com/saltstack/salt/blob/2014.1/conf/master#L385

Git fileserver backend configuration.
When using the git fileserver backend at least one git remote needs to be
defined.

The user running the salt master will need read access to the repo.
Look in :doc:`/ssh/client/doc/index` for more details.

If the salt-master act also as the git server, look for
:doc:`/git/server/doc/pillar` exact pillars keys details.

salt_master:pillar
~~~~~~~~~~~~~~~~~~

Specify a remote git repo for using as ext pillar.

Default: ``False``

``False`` means not use.

If the :doc:`index` act also as the :doc:`/git/server/doc/index`, look for
exact :doc:`/git/server/doc/pillar` keys details.

salt_master:pillar:branch
~~~~~~~~~~~~~~~~~~~~~~~~~

Git branch when checkout remote git repo.

salt_master:pillar:remote
~~~~~~~~~~~~~~~~~~~~~~~~~

Git path to use for remote git repo.

salt_master:workers
~~~~~~~~~~~~~~~~~~~

Numbers of workers.

.. TODO: use number of cores

Default: ``5``

salt_master:loop_interval
~~~~~~~~~~~~~~~~~~~~~~~~~

.. https://github.com/saltstack/salt/blob/2014.1/conf/master#L80

The loop_interval option controls the seconds for the master's maintinance
process check cycle. This process updates file server backends, cleans the
job cache and executes the scheduler.

Default: ``60``

salt_master:keep_jobs_hours
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. https://github.com/saltstack/salt/blob/2014.1/conf/master#L73

Set the number of hours to keep old job information in the job cache

Default: ``24``
