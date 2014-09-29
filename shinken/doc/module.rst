.. Copyright (c) 2014, Quan Tong Anh
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
.. Neither the name of Quan Tong Anh nor the names of its contributors may be used
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

Introduction
============

From version 2.0, Shinken came with no modules, you need to install them
manually from shinken.io using shinken cli::

  /usr/local/shinken/bin/shinken install webui

What it actually does in this step are:

- download the file from ``shinken.io/grab/webui.tar``
- extract the module code into ``/var/lib/shinken/modules/webui/``
- and put the configuration file in ``/etc/shinken/modules/webui.cfg``

Mirror
======

By default, the timeout value (300 seconds) is hard-coded in ``cli/shinkenio/cli.py``.
So, you may got an error when installing via a slow network::

  Sep 18 11:13:15 salt-minion[8893] salt.state: {'pid': 9780, 'retcode': 0,
  'stderr': '', 'stdout': "Grabbing : \nwebui\nThere was a critical error : (28,
  'Operation timed out after 300000 milliseconds with 3912 out of 3580384 bytes
  received')\nThe package webui cannot be found"}

It's the reason why we would like to mirror these modules to our archive
server, then install from that via ``--local`` option.

- Go to shinken.io
- Search for specific module
- Go to homepage ``https://github.com/shinken-monitoring/mod-webui``
- Download source ``https://github.com/shinken-monitoring/mod-webui/archive/master.zip``
- Extract, rename the folder to the same as the package name (``webui``)
- Re-pack, copy to the archive server
