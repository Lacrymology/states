Pillar
======

Mandatory
---------

Example::

  proftpd:
    - list
    password: userpass

proftpd:password
~~~~~~~~~~~~~~~~

PostgreSQL user password.

Optional
--------

Example::

  proftpd:
    deployments:
  destructive_absent: False

proftpd:deployments
~~~~~~~~~~~~~~~~~~~

List deployments of proftpd.

Default: [] by default of that pillar key.

destructive_absent
~~~~~~~~~~~~~~~~~~

Remove all data when run absent.sls.

Default: ``False`` by default of that pillar key.