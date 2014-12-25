Monitor
=======

Mandatory
---------

.. |deployment| replace:: roundcube

.. _monitor-roundcube_uwsgi_master:

roundcube_uwsgi_master
~~~~~~~~~~~~~~~~~~~~~~

Roundcube uWSGI Master Process.

.. _monitor-roundcube_uwsgi_worker:

roundcube_uwsgi_worker
~~~~~~~~~~~~~~~~~~~~~~

Roundcube uWSGI Workers Processes.

.. _monitor-roundcube_uwsgi_ping:

roundcube_uwsgi_ping
~~~~~~~~~~~~~~~~~~~~

Roundcube uWSGI Ping.

.. include:: /postgresql/doc/monitor.inc

.. _monitor-roundcube_nginx_http:

roundcube_nginx_http
~~~~~~~~~~~~~~~~~~~~

Roundcube HTTP Protocol work properly.

.. _monitor-roundcube_nginx_https:

roundcube_nginx_https
~~~~~~~~~~~~~~~~~~~~~

Roundcube HTTPS Protocol work properly.

.. _monitor-roundcube_nginx_https_certificate:

roundcube_nginx_https_certificate
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Roundcube HTTPS Certificate Expiration is reached or not.

.. _monitor-roundcube_ssl_configuration:

roundcube_ssl_configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Roundcube SSL Configuration is good or not.

.. include:: /backup/doc/monitor_postgres_procs.inc

.. include:: /backup/doc/monitor.inc
