Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/s3cmd/doc/index` :doc:`/s3cmd/doc/pillar`

Mandatory
---------

Example::

  backup:
    s3:
      secret_key: aws_s3secretkey
      access_key: aws_s3acccesskey
      bucket: example
      path: /path/to/backup

.. _pillar-backup-s3-secret_key:

backup:s3:secret_key
~~~~~~~~~~~~~~~~~~~~

`Amazon <https://aws-portal.amazon.com/gp/aws/developer/account/index.html?action=access-key>`_
access key.

.. _pillar-backup-s3-access_key:

backup:s3:access_key
~~~~~~~~~~~~~~~~~~~~

Amazon account secret key.

.. _pillar-backup-s3-bucket:

backup:s3:bucket
~~~~~~~~~~~~~~~~

`Amazon S3 bucket <http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html>`_
name.

.. _pillar-backup-s3-path:

backup:s3:path
~~~~~~~~~~~~~~

Path in
`S3 bucket <http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html>`_
where to push backed up archive files.
