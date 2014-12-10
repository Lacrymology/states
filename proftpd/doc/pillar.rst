Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`
- :doc:`/postgresql/doc/index` :doc:`/postgresql/doc/pillar`

Mandatory
---------

Example::

  proftpd:
    password: userpass

.. _pillar-proftpd-password:

proftpd:password
~~~~~~~~~~~~~~~~

:doc:`/postgresql/doc/index` user password.

Optional
--------

Example::

  proftpd:
    accounts:
      bob: pass
    db:
      name: proftpd
      password: foo
      username: proftpd

proftpd:accounts
~~~~~~~~~~~~~~~~

Accounts that will be inserted into :doc:`/postgresql/doc/index` database.
Data formed as a dictionary ``userid``:``passwd``.

Default: Empty dictionary (``{}``) - no accounts.

proftpd:db:name
~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/name.inc

Default: ``proftpd``.

proftpd:db:username
~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/username.inc

Default: ``proftpd``.

proftpd:db:password
~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/password.inc

Conditional
-----------

proftpd:accounts:{{ username }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Username to login.
