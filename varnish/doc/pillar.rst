:Copyrights: Copyright (c) 2013, Diep Pham
             All rights reserved.

             Redistribution and use in source and binary forms, with
             or without modification, are permitted provided that the
             following conditions are met:

             1. Redistributions of source code must retain the above
             copyright notice, this list of conditions and the following
             disclaimer.

             2. Redistributions in binary form must reproduce the
             above copyright notice, this list of conditions and the following
             disclaimer in the documentation and/or other materials provided
             with the distribution.

             THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
             CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
             WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
             WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
             PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
             COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
             INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
             CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
             PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
             DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
             CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
             CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
             OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
             SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
             DAMAGE.
:Authors: - Van Diep Pham <favadi@robotinfra.com>

Pillar
=======

Optional
--------

Example::

  varnish:
  extra_config: |
    # Useless comment
  storage_backend: file
  file_size: 2G

varnish:default_backend_host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

IP address of default varnish backend.

Default: ``127.0.0.1``.

varnish:default_backend_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Port of default varnish backend.

Default: ``8080``.

varnish:extra_config
~~~~~~~~~~~~~~~~~~~~

Extra config to put in ``/etc/varnish/default.vcl``.

.. caution::

   Use with caution!  See `Varnish Configuration Language
   Document (VCL)
   <https://www.varnish-cache.org/docs/3.0/reference/vcl.html>`_.

   Invalid VCL will cause varnish daemon fail to start.

varnish:nfiles
~~~~~~~~~~~~~~

Maximum number of open files (for ulimit -n)

Default: ``131072``

varnish:memlock
~~~~~~~~~~~~~~~

Maximum locked memory size (for ulimit -l). Used for locking the
shared memory login memory.

Default: ``82000``

varnish:listen_address
~~~~~~~~~~~~~~~~~~~~~~

IP address to listen for client requests.

Possible values: A valid host name, IPv4 or IPv6 adress. If empty,
varnish will listen on all interfaces.

Default: empty

varnish:listen_port
~~~~~~~~~~~~~~~~~~~

TCP port to listen for client requests.

Default: ``80``

varnish:telnet_address
~~~~~~~~~~~~~~~~~~~~~~

IP address to listen for management commands.

Possible values: A valid host name, IPv4 or IPv6 adress. If empty,
varnish will listen on all interfaces.

Default: ``127.0.0.1``

varnish:telnet_port
~~~~~~~~~~~~~~~~~~~

TCP port to listen for management commands.

Default: ``6082``

varnish:storage_backend
~~~~~~~~~~~~~~~~~~~~~~~

What storage backend varnish should use. See `varnish user's guide
<https://www.varnish-cache.org/docs/trunk/users-guide/storage-backends.html>`_
for more information.

This state does not support config for `persistent
<https://www.varnish-cache.org/docs/trunk/users-guide/storage-backends.html#persistent-experimental>`_
storage backend.

Possible values: ``file``, ``malloc``

Default: ``malloc``

varnish:malloc_size
~~~~~~~~~~~~~~~~~~~

Maximum size varnish will allocate when using malloc storage backend.

Possible values: a number and one of following suffixes.

- K, k: kilobytes
- M, m: megabytes
- G, g: gigabytes
- T, t: terabytes

Default: ``2G``

varnish:file_path
~~~~~~~~~~~~~~~~~

The path to varnish storage file when using file storage backend.

Default: ``/var/lib/varnish/<hostname>/varnish_storage.bin``

varnish:file_size
~~~~~~~~~~~~~~~~~

The file size of varnish storage file when using file storage backend.

Possible values: a number and one of following suffixes.

- K, k: kilobytes
- M, m: megabytes
- G, g: gigabytes
- T, t: terabytes
- %: use up to this percent of available disk space

Default: ``2G``

.. note::

   If specify this value with suffix ``M`` or ``G``, this state will
   pre-allocate exactly this value of disk space before start
   varnish. This is a solution to prevent disk fragment.

   The pre-allocate action will not happen if the unit is ``K`` (too
   small) or ``T`` (too much time to pre-allocate).
