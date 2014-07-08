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
`gitfs <http://salt.readthedocs.org/en/latest/topics/tutorials/gitfs.html>`__.

Do the same for develoment pillars.

And then formulas can be tested.

If any bug or additional need to be done, repeat the process.

Here is a faster way to develop formulas, :doc:`/salt/minion/doc/index` do have
the ability to
`run without a master <http://salt.readthedocs.org/en/latest/topics/tutorials/quickstart.html>`__

There is limitations, some feature don't work such as:

- `mine <http://salt.readthedocs.org/en/latest/topics/mine/>`__
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
`scp <http://www.openbsd.org/cgi-bin/man.cgi?query=scp&sektion=1>`__
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

Install minion::

  /root/salt/states/salt/minion/bootstrap.sh [minion-name-that-match-pillars]

Apply formula
-------------

If there is already a role (see :doc:`intro`), an appropriate ``top.sls`` and
pillars value, just run::

  salt-call state.highstate

To apply everything. Or specify a single formula, such as::

  salt-call state.sls vim
