Pillar
======

Optional
--------

influxdb:databases
~~~~~~~~~~~~~~~~~~

List of :doc:`index` databases to create.

Default: doesn't create any database (``[]``).

influxdb:admin
~~~~~~~~~~~~~~

Create administrator account and enable authentication if provided.

.. warning::

   With current version of :doc:`index` (0.9.1), admin interface doesn't work
   when authentication enabled.
   Bug report: https://github.com/influxdb/influxdb/issues/3222

Format::

  influxdb:
    admin:
      user: {{ admin_user }}
      password: {{ admin_password }}

Default: disable authentication (``False``).
