Monitor
=======

Mandatory
---------

.. |deployment| replace:: graphite

.. _monitor-graphite_uwsgi_master:

graphite_uwsgi_master
~~~~~~~~~~~~~~~~~~~~~

Graphite uWSGI Master Process is running.

.. _monitor-graphite_uwsgi_worker:

graphite_uwsgi_worker
~~~~~~~~~~~~~~~~~~~~~

Graphite uWSGI Workers Process is running.

.. _monitor-graphite_uwsgi_ping:

graphite_uwsgi_ping
~~~~~~~~~~~~~~~~~~~

Graphite uWSGI Ping checks successfully.

.. _monitor-graphite_nginx_http:

graphite_nginx_http
~~~~~~~~~~~~~~~~~~~

:doc:`/graphite/doc/index` :doc:`/nginx/doc/index` :ref:`glossary-HTTP` Protocol works properly

.. _monitor-graphite_nginx_https:

.. include:: /nginx/doc/monitor_ssl.inc

.. include:: /postgresql/doc/monitor.inc

.. include:: /backup/doc/monitor_postgres_procs.inc

.. include:: /backup/doc/monitor_postgres_age.inc
