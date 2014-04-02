Troubleshoot Salt-master
========================

salt-master does not know your new branch in gitfs?
---------------------------------------------------

When run salt state against a specific branch (assuming that branch exists
on remote git repository) but salt returns error said it cannot found that
environment (salt maps git branch/tags to salt environment). To fix this
problem, follow below steps:

Stop salt-master::

  service salt-master stop

Remove gitfs cache directory::

  rm -rf /var/cache/salt/master/gitfs

Restart salt-master::

  service salt-master start

Environment specify
-------------------

When used with gitfs, salt maps git branch/tags to salt environment.

Salt environment can be specified throught env argument. Below example
run ``vim`` formula from environent ``develop``::

  salt-call state.sls vim env=develop

Some branch modify _module/_states may need to sync them first::

  salt-call saltutil.sync_all env='branchXYZ'

Notice ``salt-call state.highstate`` does not accept env argument.
