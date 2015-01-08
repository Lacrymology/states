Formulas Development
====================

Introduction
------------

If you don't plan to :doc:`hacking` but rather just develop formulas, the most
simple way is the less effective:

Have a dedicated development VM added to :doc:`/salt/master/doc/index`.

A new formula can be created in a sandbox, git used to push those files into
the :doc:`/git/server/doc/index` and wait until :doc:`/salt/master/doc/index`
refresh
`gitfs <http://salt.readthedocs.org/en/latest/topics/tutorials/gitfs.html>`_.

Do the same for develoment pillars.

And then formulas can be tested.

If any bug or additional need to be done, repeat the process.

Here is a faster way to develop formulas, :doc:`/salt/minion/doc/index` do have
the ability to
`run without a master <http://salt.readthedocs.org/en/latest/topics/tutorials/quickstart.html>`_

There is limitations, some feature don't work such as:

- `mine <http://salt.readthedocs.org/en/latest/topics/mine/>`_
- gitfs
- pillar gitfs

There is a way to fake the ``mine`` module and stop using gitfs make things run
a lot faster.

Test Host
---------

To use the master-less (local mode), an empty test machine (VM) is required.

.. warning::

  Never use an existing deployed virtual machine to perform test, you'll very
  likely to break it.

That host must not be running a :doc:`/salt/minion/doc/index` already. Thus it's
not linked to the :doc:`/salt/master/doc/index`.

Git Repositories
----------------

You need checkout the following 3 repositories into your own
workstation:

- Common states (where this file is)
- Client specific states (where the roles are)
- Pillar repository

If you don't have or need a client specific states, just create an empty
fake repo::

  mkdir /tmp/repo
  git init /tmp/repo

And use ``/tmp/repo``

Bootstrap Archive
-----------------

Create an archive for :doc:`/salt/master/doc/index` bootstrap purpose.

Check the :download:`/bootstrap_archive.py` script at the root of the common
repository for instruction.

Copy the file with
`scp <http://www.openbsd.org/cgi-bin/man.cgi?query=scp&sektion=1>`_
to test VM. And extract it there, but make sure it you use ``tar`` from the root
of the file-system (``/``). As everything must be in a specific directory:
``/root/salt``. A safe place to copy it is in ``/tmp/archive.tar.gz``.

.. warning::

  Don't try to use an other directory than ``/root/salt`` it won't work.

Salt-Minion Installation
------------------------

Then on the server run::

  cd /
  tar -xvzf /tmp/archive.tar.gz

Install :doc:`/salt/minion/doc/index`::

  /root/salt/states/salt/minion/bootstrap.sh [minion-name-that-match-pillars]

Apply formula
-------------

If there is already a role (see :doc:`intro`), an appropriate ``top.sls`` and
pillars value, just run::

  salt-call state.highstate

To apply everything. Or specify a single formula, such as::

  salt-call state.sls vim

Develop
-------

The formula can be edited directly on the development host and apply directly.
Please follow :doc:`write_formula`.

Once it's tested properly, new or updated files can be copied back to developer
workstation and changes applied to git repositories.

.. warning::

  As the source are in ``/root/salt``, just make sure the new formula don't
  perform any change in that directory.
