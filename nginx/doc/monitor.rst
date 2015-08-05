Monitor
=======

Mandatory
---------

.. _monitor-nginx_status:

nginx_status
~~~~~~~~~~~~

Send a request to the status page (``/nginx_status``) and check if it returned
a response successfully (``200 OK``).

.. _monitor-nginx_workers:

nginx_workers
~~~~~~~~~~~~~

Check the number of processes with arguments that contains ``nginx: worker``.

.. _monitor-nginx_master:

nginx_master
~~~~~~~~~~~~

Check if there is only one process with arguments that contains
``nginx: master`` is running.

Optional
--------

.. _monitor-nginx_status_ipv6:

nginx_status_ipv6
~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-nginx_status` but for :ref:`glossary-IPv6`.
