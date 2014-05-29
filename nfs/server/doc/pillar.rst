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

.. include:: /doc/include/add_firewall.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/firewall`

Mandatory
---------

Example::

  nfs:
    allow: 192.168.122.1, 192.168.122.8

nfs:allow
~~~~~~~~~

List of allow hosts.

Optional
--------

Example::

  nfs:
    deny: ALL
    procs: 8
    exports:
      /srv/salt:
        192.168.122.0/24: rw,sync,no_subtree_check,no_root_squash
        192.168.32.21: ro
      /tmp:
        192.168.122.1: rw,sync,no_subtree_check,no_root_squash

nfs:deny
~~~~~~~~

List of deny hosts.

Default: ``ALL``.

nfs:exports
~~~~~~~~~~~

Files to share and hosts that can access to it with specified options.

Default: empty list.

nfs:procs
~~~~~~~~~

Numbers of nfs processes.

Default: ``8``.
