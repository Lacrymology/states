Monitor
=======

Mandatory
---------

.. |deployment| replace:: graphite

.. _monitor-graphite_uwsgi_master:

graphite_uwsgi_master
~~~~~~~~~~~~~~~~~~~~~

Graphite :doc:`/uwsgi/doc/index` Master Process is running.

.. _monitor-graphite_uwsgi_worker:

graphite_uwsgi_worker
~~~~~~~~~~~~~~~~~~~~~

Graphite :doc:`/uwsgi/doc/index` Workers Process is running.

.. _monitor-graphite_uwsgi_ping:

graphite_uwsgi_ping
~~~~~~~~~~~~~~~~~~~

Graphite :doc:`/uwsgi/doc/index` Ping checks successfully.

.. _monitor-graphite_nginx_http:

graphite_nginx_http
~~~~~~~~~~~~~~~~~~~

:doc:`index` :doc:`/nginx/doc/index` :ref:`glossary-HTTP`
Protocol works properly

.. _monitor-graphite_nginx_https:

.. include:: /postgresql/doc/monitor.inc

.. include:: /backup/doc/monitor_postgres_procs.inc

.. include:: /backup/doc/monitor_postgres_age.inc

Optional
--------

.. include:: /nginx/doc/monitor_ssl.inc

Only use if an :ref:`glossary-IPv6` address is present.

.. include:: /nginx/doc/monitor_ipv6.inc
