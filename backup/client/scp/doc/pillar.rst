.. Copyright (c) 2013, Hung Nguyen Viet
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
.. Neither the name of Hung Nguyen Viet nor the names of its contributors may be used
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

.. include:: /doc/include/add_pillar.inc

- :doc:`/ssh/client/doc/index` :doc:`/ssh/client/doc/pillar`

Mandatory
---------

Example::

  backup_server:
    address: 192.168.1.1
    fingerprint: 00:de:ad:be:ef:xx
    subdir: common_backup

backup_server:address
~~~~~~~~~~~~~~~~~~~~~

IP/Hostname of :doc:`/backup/server/doc/index`.

backup_server:subdir
~~~~~~~~~~~~~~~~~~~~

Sub directory of ``/var/lib/backup`` to backup file to. This uses salt minion
IDs of backup clients as default value. With this value, each minion will
backup files to a separate directory under ``/var/lib/backup``.

Default: rendered value of `{{ grains['id'] }}``

backup_server:fingerprint
~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/ssh/doc/index`
`fingerprint <http://en.wikipedia.org/wiki/Public_key_fingerprint>`__
of backup :doc:`/backup/server/doc/index`.

This is an example how to retrieve `github <https://github.com>`__
:doc:`/ssh/doc/index` fingerprint::

  ssh-keyscan github.com > /tmp/github.pub
  ssh-keygen -lf /tmp/github.pub

Output is key's fingerprint::

  2048 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48 github.com (RSA)
