|deployment|\_backup_postgres_age
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. if you update the following, please update
.. openerp_backup_postgres_{{ company }}_age as well

Check if the :doc:`/postgresql/doc/index` database is backed up less than
:ref:`pillar-backup-age` hours ago and its size is greater than zero (``0``).

