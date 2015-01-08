Usage
=====

If the host that apply the formula is, in fact, a :doc:`/virtualbox/doc/index`
virtual machine, everything is automaticaly applied, no need for pillars, as
long as the shared folders are ``auto-mount``.

.. warning::

  Shared folder in :doc:`/virtualbox/doc/index` user interface must be
  ``auto-mount`` and will be automatically mounted to ``/media/`` under the sub
  directory of choosed name.

  If ``auto-mount`` is turned off, volume must be mounted using
  ``mount.mounted`` state, or ``mount.mount`` module, or with
  ``mount -t vboxsf sf_$share_name $mount_point``.

.. note::

  All shared auto-mounted start with ``sf_`` prefix.
