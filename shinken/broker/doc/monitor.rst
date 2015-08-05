Monitor
=======

Mandatory
---------

.. |deployment| replace:: shinken.broker

shinken_broker_procs
~~~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

shinken_broker_port
~~~~~~~~~~~~~~~~~~~

Check if the :doc:`index` port is open.

shinken_broker_port_remote
~~~~~~~~~~~~~~~~~~~~~~~~~~

Check if the :doc:`index` port can be reached from the
:doc:`/shinken/doc/index` :doc:`/shinken/poller/doc/index`.

shinken_broker_http_port
~~~~~~~~~~~~~~~~~~~~~~~~

Check if the `WebUI
<http://shinken.readthedocs.org/en/latest/11_integration/webui.html>`_ port is
open.

If not, make sure that the ``webui`` module is installed::

  /usr/local/shinken/bin/shinken -c /var/lib/shinken/.shinken.ini inventory

and loaded. Also take a look at the log file
``/var/log/upstart/shinken-broker.log`` to know what happens.

.. note::

   In high availability mode, one is active while another nodes are spare. So,
   it's normal to see this check is CRITICAL on the spare nodes.

shinken_broker_http
~~~~~~~~~~~~~~~~~~~

Check if the web UI is working by sending a :ref:`glossary-http` request to the
``/user/login`` URI and expecting a ``200 OK`` response.

shinken_broker_web_cluster
~~~~~~~~~~~~~~~~~~~~~~~~~~

This uses `business rules
<http://shinken.readthedocs.org/en/latest/06_medium/business-rules.html>`_ to
check if there is one broker is active.
If all nodes are down, only one notification would be sent, rather than
multiple.

.. include:: /nginx/doc/monitor.inc

Optional
--------

Only use if :ref:`pillar-shinken-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc

Only use if :ref:`pillar-ip_version` is set to ``ipv6`` or ``both``.

.. include:: /nginx/doc/monitor_ipv6.inc
