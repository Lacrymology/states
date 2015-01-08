Pillar
======

Optional
--------

Example::

  backup:
    xz_memlimit: 64

.. _pillar-backup-xz_memlimit:

backup:xz_memlimit
~~~~~~~~~~~~~~~~~~

Memory limit to `xz <https://en.wikipedia.org/wiki/Xz>`_ compressor when it run
(in MB).

Default: limits to ``64`` MB.

.. _pillar-backup-age:

backup:age
~~~~~~~~~~

Age of backup files that will be considered fresh enough.

Default: ``48`` hours.
