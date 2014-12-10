Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/cron/doc/index` :doc:`/cron/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/rsync/doc/index` :doc:`/rsync/doc/pillar`
- :doc:`/ssh/server/doc/index` :doc:`/ssh/server/doc/pillar`

.. warning::

  Make sure that :doc:`/ssh/server/doc/index` :doc:`/ssh/server/doc/pillar`
  key :ref:`pillar-ssh-server-extra_configs` allow the user `git` in.

Mandatory
---------

Example::

  salt_archive:
    hostnames:
      - archive.example.com

.. _pillar-salt_archive-hostnames:

salt_archive:hostnames
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

Example::

  salt_archive:
    source: rsync://archive.robotinfra.com/archive/
    delete: True
    ssl: mykeyname
    keys:
      00daedbeef: ssh-dss

.. _pillar-salt_archive-source:

salt_archive:source
~~~~~~~~~~~~~~~~~~~

:doc:`/rsync/doc/index` server used as the source for archived files.

Default: Act as an upstream server (``False``).

.. _pillar-salt_archive-ssl:

salt_archive:ssl
~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-salt_archive-keys:

salt_archive:keys
~~~~~~~~~~~~~~~~~

Dict of :doc:`/ssh/client/doc/index` keys allowed to log in user.

Default: allow no :doc:`/ssh/client/doc/index` key (``{}``).

.. _pillar-salt_archive-delete:

salt_archive:delete
~~~~~~~~~~~~~~~~~~~

Delete file in target server that does not exist in source server.

Default: don't delete file in target server (``False``).

.. _pillar-salt_archive-max_age:

salt_archive:max_age
~~~~~~~~~~~~~~~~~~~~

Max time in seconds before an archive server is considered out of sync.

Default: archive server with last synchronization time excesss
``3600`` seconds is considered out of sync.

.. _pillar-salt_archive-ssl_redirect:

salt_archive:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

Rsync
-----

This state also need the following pillar for :doc:`/rsync/doc/index` formula::

  rsync:
    uid: salt_archive
    gid: salt_archive
    'use chroot': yes
    shares:
      archive:
        path: /var/lib/salt_archive
        'read only': true
        'dont compress': true
        exclude: .* incoming

You can change the name 'archive' by something else. but you need to change your
``files_archive`` pillar value accordingly.

Clamav
------

:doc:`/clamav/doc/index` formula :doc:`/clamav/doc/pillar` key
:ref:`pillar-clamav-db_mirrors` is also used to mirror :doc:`/clamav/doc/index` databases.
