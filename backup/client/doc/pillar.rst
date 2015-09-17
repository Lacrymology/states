Pillar
======

Mandatory
---------

Example::

  backup_storage: scp

.. _pillar-backup_storage:

backup_storage
~~~~~~~~~~~~~~

Type of backup storage client that is supported.

Available values are:

- ``local`` - :doc:`/backup/client/local/doc/index`
- ``scp`` - :doc:`/backup/client/scp/doc/index`
- ``s3`` - :doc:`/backup/client/s3/doc/index`
- ``noop`` - :doc:`/backup/client/noop/doc/index` (for :doc:`/test/doc/index`
  only)
