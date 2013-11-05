Running Integration Tests
=========================

:copyrights: Copyright (c) 2013, Bruno Clermont

             All rights reserved.

             Redistribution and use in source and binary forms, with or without
             modification, are permitted provided that the following conditions
             are met:

             1. Redistributions of source code must retain the above copyright
             notice, this list of conditions and the following disclaimer.
             2. Redistributions in binary form must reproduce the above
             copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
             "AS IS" AND ANY EXPRESS OR IMPLIED ARRANTIES, INCLUDING, BUT NOT
             LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
             FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
             INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES(INCLUDING,
             BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
             LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
             LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
             ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
             POSSIBILITY OF SUCH DAMAGE.
:authors: - Bruno Clermont

Git Repositories
----------------

You need checkout the following 3 repositories into your own
workstation:

- Common (where this file is)
- Client specific (where the roles are)
- Pillar repository

Bootstrap Archive
-----------------

Create an archive for salt-master bootstrap purpose.

Check the ``bootstrap_archive.py`` script at the root of the common repository
for instruction.

Copy the output of the archive to the server you want to install the
testing host.

Salt-Minion Installation
------------------------

Then on the server run::

  cd /
  tar -xvzf /tmp/archive.tar.gz

Install minion::

  /root/salt/states/salt/minion/bootstrap.sh integration-[whatever]

Quick shortcut:

  cd /; tar -xzf /tmp/archive.tar.gz; /root/salt/states/salt/minion/bootstrap.sh integration

If you need to troubleshoot something between, you might ends with vim
uninstalled, to install it run::

  salt-call state.sls vim

Integration Tests
-----------------

To launch tests::

  /root/salt/states/test/integration.py -c

There is more than 500 tests, it takes time and generate a lot of logs, so I
suggest:

  nohup /root/salt/states/test/integration.py -c > /tmp/test.log

You can launch specific test such as::

  nohup /root/salt/states/test/integration.py -c States.test_apt > /tmp/test.log

To get the list of available tests run::

  /root/salt/states/test/integraiton.py --list
