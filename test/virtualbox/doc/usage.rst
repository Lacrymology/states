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

Run tests
---------

Follow :doc:`/doc/run_tests.rst` as usual.

The wrapper ``test/virtualbox/run.py`` can be used to ease test runs and
redirect logs to the ``test_results`` VirtualBox shared folder to save on disk
space of test VM.

Feel free to revert VM to a previous snapshot anytime to repeat test process.
