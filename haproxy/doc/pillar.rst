Pillar
======

.. include:: /doc/include/pillar.inc

Mandatory
---------

Example::

  haproxy:
    instances:
      ssl-relay:
        port: 8443
        backends:
          nodes:
            servers:
              www-1: 1.1.1.1:80
              www-2: 2.2.2.2:80

.. _pillar-haproxy-instances:

haproxy:instances
~~~~~~~~~~~~~~~~~

Data formed as a dictionary with key is the instance name and value is another
dictionary for ``ip``, ``port``, ``config``, ...

.. _pillar-haproxy-instances-instance-port:

haproxy:instances:{{ instance }}:port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Define a port for which the proxy will accept connections for the IP address
specified above.

.. _pillar-haproxy-instances-instance-backends:

haproxy:instances:{{ instance }}:backends
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A dictionary of backends with key is the backend name and value is another
dictionary of the backend servers and additional config. See details below.

.. _pillar-haproxy-instances-instance-backends-backend:

haproxy:instances:{{ instance }}:backends:{{ backend }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Configuration for the {{ backend }}.

.. _pillar-haproxy-instances-instance-backends-backend-servers:

haproxy:instances:{{ instance }}:backends:{{ backend }}:servers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A dictionary with key is the backend server name and value is `<ip>`:`<port>`.

Optional
--------

Example::

  haproxy:
    global:
      maxconn: 4096
    instances:
      ssl-relay:
        ssl: local
        mode: http
        ip: 1.2.3.4
        backends:
          nodes:
            mode: http
            balance: roundrobin
            additional:
              - option forwardfor

.. _pillar-haproxy-global-maxconn:

haproxy:global:maxconn
~~~~~~~~~~~~~~~~~~~~~~

The maximum number of concurrent connections the :doc:`index` will accept to
serve.

Default: ``4096`` concurrent connections.

.. _pillar-haproxy-instances-instance-ssl:

haproxy:instances:{{ instance }}:ssl
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-haproxy-instances-instance-ip:

haproxy:instances:{{ instance }}:ip
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The IP address the proxy binds to.

Default: listen to all valid addresses on the system (``0.0.0.0``).

.. _pillar-haproxy-instances-instance-mode:

haproxy:instances:{{ instance }}:mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The running mode or protocol of the instance. Either ``http`` or ``tcp``.

Default: ``http`` mode.

.. _pillar-haproxy-instances-instance-additional:

haproxy:instances:{{ instance }}:additional
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of additional configurations for the frontend {{ instance }}.

Default: no additional config (``[]``).

.. _pillar-haproxy-instances-instance-backends-backend-mode:

haproxy:instances:{{ instance }}:backends:{{ backend }}:mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Which mode :doc:`index` will be running in. Either ``http`` or ``tcp``.

Default: ``http`` mode.

.. _pillar-haproxy-instances-instance-backends-backend-balance:

haproxy:instances:{{ instance }}:backends:{{ backend }}:balance
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Which balancing algorithm will be used. It may be one of the following:
- `roundrobin`
- `leastconn`
- `source`
- `uri`
- `url_param`
- `hdr`

Take a look at `this
<https://cbonte.github.io/haproxy-dconv/configuration-1.5.html#4.2-balance>`_
for more details.

Default: Each server is used in turns, according to their weights
(``roundrobin``).

.. _pillar-haproxy-instances-instance-backends-backend-additional:

haproxy:instances:{{ instance }}:backends:{{ backend }}:additional
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of additional configurations for the {{ backend }}.

Default: no additional config (``[]``).
