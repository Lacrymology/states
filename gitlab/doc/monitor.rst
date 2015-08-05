Monitor
=======

Mandatory
---------

.. |deployment| replace:: gitlab

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``gitlab``.

.. _monitor-gitlab_sidekiq_procs:

gitlab_sidekiq_procs
~~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Monitor :doc:`index` `Sidekiq <http://sidekiq.org/>`_
process.

Critical:

  * There is no `Sidekiq <http://sidekiq.org/>`_ process running
  * There are more than one `Sidekiq <http://sidekiq.org/>`_ processes running

.. include:: /uwsgi/doc/monitor.inc

.. include:: /nginx/doc/monitor.inc

.. _monitor-gitlabhq_production_postgresql:

gitlabhq_production_postgresql
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check :doc:`/postgresql/doc/index` connection.

Critical: if unable to connect.

.. _monitor-gitlabhq_production_postgresql_encoding:

gitlabhq_production_postgresql_encoding
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check if :doc:`/postgresql/doc/index` database encoding is UTF8.

.. _monitor-gitlabhq_production_postgresql_not_empty:

gitlabhq_production_postgresql_not_empty
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check if :doc:`/postgresql/doc/index` database is not empty.

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc

Optional
--------

Only use if :ref:`pillar-gitlab-ssl` is turned defined.

.. include:: /nginx/doc/monitor_ssl.inc

Only use if :ref:`pillar-ip_version` is set to ``ipv6`` or ``both``.

.. include:: /nginx/doc/monitor_ipv6.inc
