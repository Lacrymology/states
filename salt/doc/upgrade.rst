Upgrade guide
=============

Tips
----

- Always run salt commands by root user (use ``sudo -sH`` to ensure env set correctly).
- Always run command from ``/`` or ``/root``, not any other directory
  because salt may have problem with setting path.

Steps
-----

Check if all salt components depend on any new package. If so, remove it
from ``test/clean.sls``.

Upgrade salt to newer version on production
===========================================

1. Decide to upgrade master first or last, this depends if old version of
salt-master works well with new version of salt-minions or not.  I chose to do
it last, but generally, you should upgrade salt-master first.

2. Choose a least important server to upgrade. I chose archive
Command to upgrade call from salt-master::

    salt archive state.sls salt.minion.upgrade env=testing test=True -vt300

If it success, run the command without ``test=True``.
By this run, you should not expect it will returns normally, something weird
will be report/return often because of salt changed after upgrade. Don't panic,
run that command again to see if everything okay.

3. Test highstate on the same server: as it is 2014.7.5 now, run::

    salt archive state.highstate test=True -vt300

wait and see, if everything look okay, run again without ``test=True``.
Now if it return okay result, you upgraded it.

4. Upgrade all remaining servers except master::

    salt -L 'server1,server2, ....' state.sls salt.minion.upgrade env=testing -vt300

5. Run that cmd again to see if everything okay (remember first run often
return error/weird messages)

6. Highstate them all.

7. Upgrade salt-master::

    salt-call state.sls salt.minion.upgrade env=testing -vt300

This will upgrade packages of salt-master, too.

Then highstate.  After success, test ping to all connected minions, run several
cmds or highstate one server to see if the communications work well.
