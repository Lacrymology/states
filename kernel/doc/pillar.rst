Pillar
======

.. include:: /doc/include/add_pillar.inc

Optional
--------

Example::

  kernel:
    modules:
      - vboxsf

.. _pillar-kernel-modules:

kernel:modules
~~~~~~~~~~~~~~

List of all required kernel modules which need to be loaded.

Default: do not load any additional kernel module (``[]``).
