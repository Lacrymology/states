Usage
=====

Web UI
------

To use the web user interface go to the server IP port ``2480``:

``http://$ip:2480/``

.. warning::

  If you experience authentication issue with Chrome, try with Firefox.

Restore Database
----------------

Get Zip File
~~~~~~~~~~~~

First you need a ``.zip`` database backup.

If using :ref:`pillar-backup_storage` ``s3``, they can be found
in :ref:`pillar-backup-s3-bucket` in the sub directory
of the :doc:`/salt/minion/doc/index` that created the backup.

You can use :doc:`/s3cmd/doc/index` to copy it such as::

  cd /tmp
  s3cmd get s3://$mybucket/$minionid/orientdb-$dbname-1969-01-01-00_00_00.zip

Create and restore
~~~~~~~~~~~~~~~~~~

You have to stop :doc:`index` service before create and restore database::

  stop orientdb

Use the :doc:`index` console to create a new database and restore the archive.

  /usr/local/bin/orientdb

In the console::

  create database plocal:/var/lib/orientdb/databases/mynewdb
  restore database /mnt/orientdb-test-1969-01-01-00_00_00.zip

Example::

  OrientDB console v.2.0.6 (build salt@2.0.6) www.orientechnologies.com
  Type 'help' to display all the supported commands.
  Installing extensions for GREMLIN language v.2.6.0

  orientdb> create database plocal:/var/lib/orientdb/databases/mynewdb

  Creating database [plocal:/var/lib/orientdb/databases/mynewdb] using the storage type [plocal]...
  Database created successfully.

  Current database is: plocal:/var/lib/orientdb/databases/mynewdb
  orientdb {db=mynewdb}> restore database /mnt/orientdb-test-1969-01-01-00_00_00.zip

  Restoring database database /mnt/orientdb-test-1969-01-01-00_00_00.zip...
  - Uncompressing file dictionary.sbt...
  [snip]
  - Uncompressing file SP_UniqueSocialAccount0.hib...
  Database restored in 2.58 seconds

If the database is already exist, connect to it with following command::

  orientdb> connect plocal:/var/lib/orientdb/databases/myolddb username password

..  warning::

    * Username and password of a database can change after restore.
    * Remember to start :doc:`index` service after restore
