Pillar
======

.. include:: /doc/include/add_pillar.inc

Mandatory
---------

Example::

  backup:
    local:
      path: /tmp/test

.. _pillar-backup-local-path:

backup:local:path
~~~~~~~~~~~~~~~~~

The directory to put back up archive files.

Optional
--------

.. _pillar-backup-local-subdir:

backup:local:subdir
~~~~~~~~~~~~~~~~~~~

Which sub directory inside :ref:`pillar-backup-local-path` to stores backup
archives.

Default: use :doc:`/salt/minion/doc/index` ID (``False``).
