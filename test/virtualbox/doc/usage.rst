Usage
=====

Create RAM Disk
---------------

.. note::

  This step is optional, but you can run the VM straight from a ramdisk.

In MacOS X::

  diskutil erasevolume HFS+ 'Ramdisk' `hdiutil attach -nomount ram://8388608`

You can move test VM into this ramdisk to speed up writes.

Create new VM from baseline
---------------------------

Create a new VM by cloning the template created in :doc:`index`.

To save on disk space, use a ``Linked`` clonse.

Once created, it can be moved to the ramdisk for extra performance.

Regenerate MAC address of network interfaces.

Configure VM
------------

Once new VM is started, log as ``root``. See :doc:`pillar` for password
information.

Edit ``/etc/network/interfaces`` if pillar key ``test:dhcp`` is ``False``.

.. note::

    It's suggested to edit ``/etc/salt/minion`` and set an id that start with
    ``integration-`` but the rest is something specific for the test.

    This way it's easy to track the test logs in ``test_results`` VirtualBox
    shared folder.

Copy formulas and pillars
-------------------------

Instead of running ``bootstrap_archive.py`` from the root of salt-common, take
it's ``.tar.gz`` output and extract it in ``/root/salt``, you can use
``/media/sf_salt/$path-to-common/test/virtualbox/bootstrap.py`` to recreated
``/root/salt``. Just need to use the same command line arguments as for
``bootstrap_archive.py``.

Run minion straight from sandbox
--------------------------------

Instead of ``/root/salt``, the minion can take it's formulas and formulas
directly from desktop sandbox.

This can be achieved by edit ``/etc/salt/minion`` and replace the following::

  file_roots:
    base:
      - /media/sf_salt/$path-to-common
  pillar_roots:
    base:
      - /media/sf_salt/$path-to-pillars

Run tests
---------

Follow :doc:`/doc/run_tests` as usual.

The wrapper ``test/virtualbox/run.py`` can be used to ease test runs and
redirect logs to the ``test_results`` VirtualBox shared folder to save on disk
space of test VM.

Feel free to revert VM to a previous snapshot anytime to repeat test process.
