Pillar
======

Optional
--------

Example::

  varnish:
  extra_config: |
    # Useless comment
  storage_backend: file
  file_size: 2G

.. _pillar-varnish-default_backend_host:

varnish:default_backend_host
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

IP address of default :doc:`index` backend.

Default: ``127.0.0.1``.

.. _pillar-varnish-default_backend_port:

varnish:default_backend_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:ref:`glossary-TCP` port of default :doc:`index` backend.

Default: port ``8080``.

.. _pillar-varnish-extra_config:

varnish:extra_config
~~~~~~~~~~~~~~~~~~~~

Extra config to put in ``/etc/varnish/default.vcl``.

Default: don't use any extra configuration (``None``).

.. caution::

   Use with caution!  See `Varnish Configuration Language
   Document (VCL)
   <https://www.varnish-cache.org/docs/3.0/reference/vcl.html>`_.

   Invalid VCL will cause :doc:`index` :ref:`glossary-daemon` fail to start.

.. _pillar-varnish-nfiles:

varnish:nfiles
~~~~~~~~~~~~~~

Maximum number of open files (for ``ulimit -n``).

Default: use no more than ``131072`` open files.

.. _pillar-varnish-memlock:

varnish:memlock
~~~~~~~~~~~~~~~

Maximum locked memory size (for ``ulimit -l``). Used for locking the
shared memory login memory.

Default: :doc:`index` will lock no more than ``82000``
bytes memory to prevent swap out.

.. _pillar-varnish-listen_address:

varnish:listen_address
~~~~~~~~~~~~~~~~~~~~~~

IP address to listen for client requests.

Possible values: A valid host name, IPv4 or IPv6 adress. If empty,
varnish will listen on all interfaces.

Default: listen on all interfaces (``''``).

.. _pillar-varnish-listen_port:

varnish:listen_port
~~~~~~~~~~~~~~~~~~~

:ref:`glossary-TCP` port to listen for client requests.

Default: port ``80``

.. _pillar-varnish-telnet_address:

varnish:telnet_address
~~~~~~~~~~~~~~~~~~~~~~

IP address to listen for management commands.

Possible values: A valid host name, IPv4 or IPv6 adress. If empty,
varnish will listen on all interfaces.

Default: ``localhost``

.. _pillar-varnish-telnet_port:

varnish:telnet_port
~~~~~~~~~~~~~~~~~~~

:ref:`glossary-TCP` port to listen for management commands.

Default: port ``6082``

.. _pillar-varnish-storage_backend:

varnish:storage_backend
~~~~~~~~~~~~~~~~~~~~~~~

What storage backend :doc:`index` should use. See `varnish user's guide
<https://www.varnish-cache.org/docs/trunk/users-guide/storage-backends.html>`_
for more information.

This state does not support config for `persistent
<https://www.varnish-cache.org/docs/trunk/users-guide/storage-backends.html#persistent-experimental>`_
storage backend.

Possible values: ``file``, ``malloc``

Default: ``malloc``

.. _pillar-varnish-malloc_size:

varnish:malloc_size
~~~~~~~~~~~~~~~~~~~

Maximum size :doc:`index` will allocate when using malloc storage backend.

Possible values: a number and one of following suffixes.

- K, k: kilobytes
- M, m: megabytes
- G, g: gigabytes
- T, t: terabytes

Default: use maxium ``256M`` bytes memory when use malloc storage backend.

.. _pillar-varnish-file_path:

varnish:file_path
~~~~~~~~~~~~~~~~~

The path to :doc:`index` storage file when using file storage backend.

Default: use /var/lib/varnish/<hostname>/varnish_storage.bin (``None``).

.. _pillar-varnish-file_size:

varnish:file_size
~~~~~~~~~~~~~~~~~

The file size of :doc:`index` storage file when using file storage backend.

Possible values: a number and one of following suffixes.

- K, k: kilobytes
- M, m: megabytes
- G, g: gigabytes
- T, t: terabytes
- %: use up to this percent of available disk space

Default: allocate ``2G`` bytes to use as :doc:`index` storage backend.

.. note::

   If specify this value with suffix ``M`` or ``G``, this state will
   pre-allocate exactly this value of disk space before start
   varnish. This is a solution to prevent disk fragment.

   The pre-allocate action will not happen if the unit is ``K`` (too
   small) or ``T`` (too much time to pre-allocate).

varnish:monitor
~~~~~~~~~~~~~~~

Provide hostname and expected response code to monitor backend response.

Example::

  varnish:
    monitor:
      hostname: archive.robotinfra.com
      response: 200 OK

Default: do not provide additional information (``False``).
