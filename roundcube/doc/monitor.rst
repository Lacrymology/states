Monitor
=======

Mandatory
---------

.. |deployment| replace:: roundcube

.. _monitor-roundcube_uwsgi_master:

roundcube_uwsgi_master
~~~~~~~~~~~~~~~~~~~~~~

:doc:`/roundcube/doc/index` :doc:`/uwsgi/doc/index` Master Process.

.. _monitor-roundcube_uwsgi_worker:

roundcube_uwsgi_worker
~~~~~~~~~~~~~~~~~~~~~~

:doc:`/roundcube/doc/index` :doc:`/uwsgi/doc/index` Workers Processes.

.. _monitor-roundcube_uwsgi_ping:

roundcube_uwsgi_ping
~~~~~~~~~~~~~~~~~~~~

:doc:`/roundcube/doc/index` :doc:`/uwsgi/doc/index` Ping.

.. include:: /postgresql/doc/monitor.inc

.. _monitor-roundcube_nginx_http:

roundcube_nginx_http
~~~~~~~~~~~~~~~~~~~~

:doc:`/roundcube/doc/index` :ref:`glossary-HTTP` Protocol work properly.

.. _monitor-roundcube_nginx_https:

roundcube_nginx_https
~~~~~~~~~~~~~~~~~~~~~

.. TODO: REFER TO SSL PILLAR!!!

:doc:`/roundcube/doc/index` :ref:`glossary-HTTPS` Protocol work properly.

.. _monitor-roundcube_nginx_https_certificate:

roundcube_nginx_https_certificate
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/roundcube/doc/index` :ref:`glossary-HTTPS` Certificate Expiration is reached or not.

.. _monitor-roundcube_ssl_configuration:

roundcube_ssl_configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`/roundcube/doc/index` :doc:`/ssl/doc/index` Configuration is good or not.

.. include:: /backup/doc/monitor_postgres_procs.inc

.. include:: /backup/doc/monitor.inc
