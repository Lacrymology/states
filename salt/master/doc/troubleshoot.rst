Troubleshoot
============

salt-master does not know your new branch in gitfs?
---------------------------------------------------

When run Salt state against a specific branch (assuming that branch exists
on remote :doc:`/git/doc/index` repository) but :doc:`/salt/doc/index` returns
error said it cannot found that
environment (salt maps :doc:`/git/doc/index` branch/tags to
:doc:`/salt/doc/index` environment). To fix this
problem, follow below steps:

Stop salt-master::

  service salt-master stop

Remove gitfs cache directory::

  rm -rf /var/cache/salt/master/gitfs

Restart salt-master::

  service salt-master start

Environment specify
-------------------

When used with gitfs, :doc:`/salt/doc/index` maps :doc:`/git/doc/index`
branch/tags to :doc:`/salt/doc/index` environment.

Salt environment can be specified through ``saltenv`` argument. Below example
run ``vim`` formula from environment ``develop``::

  salt-call state.sls vim saltenv=develop

Some branch modify ``_module`` or ``_states`` may need to sync them first::

  salt-call saltutil.sync_all saltenv='branchXYZ'

..note::

   ``salt-call state.highstate`` does not accept ``saltenv`` argument.

Remount Error
-------------

When you run :download:`bootstrap_archive.py </bootstrap_archive.py>` to
install :doc:`index` on version `0.17.2`::

  /root/salt/states/salt/master/bootstrap.sh [minion id]

You will got this error::

  Command 'mount -o rw,noatime,errors=remount-ro,barrier=0 -t ext4 /dev/vda  ' failed with return code: 1

This is a bug of :doc:`/salt/doc/index` version `0.17.2`.
An update will fix the error.
