Installation
============

Archive VM
----------

This VM run the following services:

- Salt archive mirror with:

  * Mirror of internally used :doc:`python/doc/index` :doc:`pip/doc/index`
    packages.
  * :doc:`clamav/doc/index` database mirror, updated daily.
  * Multiple Ubuntu PPA and mirrored files.

- APT cache proxy server

Create VM
~~~~~~~~~

Install https://www.virtualbox.org and create a virtual machine with
http://releases.ubuntu.com/12.04/ubuntu-12.04.5-server-amd64.iso.torrent or
32 bits.

- 32 bits will requires less disk space.
- No need to create a swap partition.
- 6 Gb is probably enough.
- Start with 512 Mb of memory. This will be changed later.
- Bridge network
- Use ``virtnet`` network card type
- Define two **Shared Folders** in :doc:`virtualbox/doc/index` UI, both
  ``Auto-mount``:

  * ``salt`` that point to the local checkout of salt-common and
    non-common repositories.
  * ``test_results`` map to a directory writeable where logs will ends.

Once Ubuntu installed, reboot on disk.

Installation
~~~~~~~~~~~~

.. warning::

   Don't forget to ``set HOME=/root`` before.

Bootstrap the VM the same way as any other with ``salt/minion/bootstrap.sh``,
but make sure the minion id starts with ``ci-vm-support-``.

Then highstate it.

Resize
~~~~~~

At this point, the VM can be shutdown, memory reduced to 128 Mb (32 bits).
Cap CPU usage in VirtualBox UI too.
And boot up with new settings.

Static IP
~~~~~~~~~

IP address of VM can change over time, it's recommended to switch to a static
IP.

Note the IP dynamic, dynamic or not, and insert it into test pillar in
``test:proxy_server`` pillar key.

Virtual Machine baseline
------------------------

The VM baseline is the starting point to all test VMs.
It must contains as less as possible.

Virtualbox
~~~~~~~~~~

Install https://www.virtualbox.org and create a virtual machine with
http://releases.ubuntu.com/12.04/ubuntu-12.04.5-server-amd64.iso.torrent or
32 bits.

4 Gb seem enough for now.

Test Pillars
~~~~~~~~~~~~

Production pillar values for ``robotinfra/ci_support.sls`` use the hostnames
``apt.local`` and ``archive.local``, update test pillar to refer to them.

Go to http://mirrors.ubuntu.com/mirrors.txt and pick a local mirror. And make
sure those pillar keys in ``integration.sls`` are like this::

  {% set mirror = 'mirror-fpt-telecom.fpt.net' %}
  apt:
    sources: |
      deb http://apt.local/{{ mirror }}/ubuntu {{ grains['oscodename'] }} main restricted universe multiverse
      deb http://apt.local/{{ mirror }}/ubuntu {{ grains['oscodename'] }}-updates main restricted universe multiverse

  files_archive: http://archive.local/

Prepare VM
~~~~~~~~~~

Use ``bootstrap_archive.py`` to set it up, like any other test VM.

Run: ``salt-call state.sls test.virtualbox``.

It will reboot at some point, to load a specific kernel.

Log with ``root`` user this time and run again:
``salt-call state.sls test.virtualbox``.

After, execute ``salt-call state.sls test.clean`` over and over until nothing
get uninstalled anymore.

.. note::

  This step is optional, based on your DHCP server.

  If your local router grant short term lease and change IP frequently,

Finally, remote ``/root/salt`` and Shutdown VM with ``poweroff``.
