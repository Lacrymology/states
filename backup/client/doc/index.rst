Backup Client
=============

Formula under this directory provides script ready for backup data to multiple
different backup solution, such as:

- :doc:`/backup/client/s3/doc/index` for backup data to
  `Amazon S3 <http://en.wikipedia.org/wiki/Amazon_S3>`
- :doc:`/backup/client/scp/doc/index` for backup data to
  :doc:`/ssh/server/doc/index` setup by :doc:`/backup/server/doc/index`.
- :doc:`/backup/client/noop/doc/index` used for testing purpose only, ignore it.

.. note::

  only one client can be used on a host.

Contents:

.. toctree::
    :glob:

    *

    ../s3/doc/index
    ../scp/doc/index
    ../noop/doc/index

