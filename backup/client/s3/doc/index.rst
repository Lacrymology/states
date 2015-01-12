S3
==

:doc:`/backup/client/doc/index` to :ref:`glossary-s3`. An
`Amazon AWS account <http://aws.amazon.com/account/>`_ is required.

.. toctree::
    :glob:

    *

S3lite
------

A custom script helps syncing to :ref:`glossary-s3` with small memory using
(:doc:`/s3cmd/doc/index` consumes a lot of memory when sync many files). It was
tested with input more than ``500 000`` files without memory problem.
To sync a file/directory, use following command::

  /usr/local/s3lite/bin/s3lite source s3://bucket/prefix

To :doc:`/nrpe/doc/index` check for S3 syncing result, use provided
:doc:`/nrpe/doc/index` script with the same arguments which was used for
backup::

  /usr/lib/nagios/plugins/check_backup_s3lite.py source s3://bucket/prefix
