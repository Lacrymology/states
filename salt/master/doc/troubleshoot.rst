.. Copyright (c) 2009, Luan Vo Ngoc
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..     this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..     notice, this list of conditions and the following disclaimer in the
..     documentation and/or other materials provided with the distribution.
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

Troubleshooting
===============

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

..note::
 
   ``salt-call state.highstate`` does not accept env argument.

Remount Error
-------------

When you run bootstrap to install Salt Master on version `0.17.2`::

  /root/salt/states/salt/master/bootstrap.sh [minion id]

You will got this error::

  Command 'mount -o rw,noatime,errors=remount-ro,barrier=0 -t ext4 /dev/vda  ' failed with return code: 1

This is a bug of salt version `0.17.2`.
An update will fix the error.
