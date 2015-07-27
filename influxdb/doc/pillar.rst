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

Format::

  influxdb:
    admin:
      user: {{ admin_user }}
      password: {{ admin_password }}

Default: disable authentication (``False``).
