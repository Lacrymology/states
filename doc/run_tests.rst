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

Running Integration Tests
=========================

As running tests is expensive in term of file copy, only the ``local`` mode is
used to run them.

Follow the same setup process as in :doc:`dev`, but make sure that you use an
hostname that starts with ``integration``::

  /root/salt/states/salt/minion/bootstrap.sh integration-[whatever]

Quick shortcut::

  cd /; tar -xzf /tmp/archive.tar.gz; /root/salt/states/salt/minion/bootstrap.sh integration

Integration Tests
-----------------

To launch tests::

  /root/salt/states/test/integration.py -c

There is more than 950 tests, it takes time and generate a lot of logs, it's
suggested to redirect logs to output::

  nohup /root/salt/states/test/integration.py -c > /tmp/test.log

You can launch specific test such as::

  nohup /root/salt/states/test/integration.py -c States.test_apt > /tmp/test.log

To get the list of available tests run::

  /root/salt/states/test/integration.py --list
