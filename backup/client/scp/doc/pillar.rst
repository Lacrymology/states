Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/ssh/client/doc/index` :doc:`/ssh/client/doc/pillar`

Mandatory
---------

Example::

  backup_server:
    address: 192.168.1.1
    fingerprint: 00:de:ad:be:ef:xx
    subdir: common_backup

.. _pillar-backup_server-address:

backup_server:address
~~~~~~~~~~~~~~~~~~~~~

IP/Hostname of :doc:`/backup/server/doc/index`.

.. _pillar-backup_server-fingerprint:

backup_server:fingerprint
~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/ssh/doc/index`
`fingerprint <http://en.wikipedia.org/wiki/Public_key_fingerprint>`__
of backup :doc:`/backup/server/doc/index`.

This is an example how to retrieve `github <https://github.com>`__
:doc:`/ssh/doc/index` fingerprint::

  ssh-keyscan github.com > /tmp/github.pub
  ssh-keygen -lf /tmp/github.pub

Output is key's fingerprint::

  2048 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48 github.com (RSA)

Optional
--------

.. _pillar-backup_server-subdir:

backup_server:subdir
~~~~~~~~~~~~~~~~~~~~

Sub directory of ``/var/lib/backup`` to backup file to. This uses salt minion
IDs of backup clients as default value. With this value, each minion will
backup files to a separate directory under ``/var/lib/backup``.

Default: use minion ID (``False``).
