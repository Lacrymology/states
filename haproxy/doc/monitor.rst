Monitor
=======

Mandatory
---------

.. |deployment| replace:: haproxy

.. _monitor-haproxy_procs:

haproxy_procs
~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-haproxy_instance_port:

haproxy_{{ instance }}_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Monitor :doc:`index` local port :ref:`glossary-TCP`
:ref:`pillar-haproxy-instances-instance-port`

.. _monitor-haproxy_instance_remote_port:

haproxy_{{ instance }}_remote_port
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Monitor :doc:`index` remote port :ref:`glossary-TCP`
:ref:`pillar-haproxy-instances-instance-port`

Optional
--------

.. _monitor-haproxy_instance_http:

haproxy_{{ instance }}_http
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check the :ref:`glossary-HTTP` connection of the {{ instance }}.

Only used if :ref:`pillar-haproxy-instances-instance-mode` is `http`.

.. _monitor-haproxy_instance_http_ipv6:

haproxy_{{ instance }}_http_ipv6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check the :ref:`glossary-HTTP` connection using :ref:`glossary-IPv6` address
of the {{ instance }}.

Only used if :ref:`pillar-haproxy-instances-instance-mode` is `http` and
:ref:`glossary-IPv6` address is present.

.. _monitor-haproxy_instance_https:

haproxy_{{ instance }}_https
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check the :ref:`glossary-HTTPS` connection of the {{ instance }}.

Only used if :ref:`pillar-haproxy-instances-instance-mode` is `http` and
:ref:`pillar-haproxy-instances-instance-ssl` is enabled.

.. _monitor-haproxy_instance_https_ipv6:

haproxy_{{ instance }}_https_ipv6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check the :ref:`glossary-HTTPS` connection using :ref:`glossary-IPv6` address
of the {{ instance }}.

Only used if :ref:`pillar-haproxy-instances-instance-mode` is `http`,
:ref:`pillar-haproxy-instances-instance-ssl` is enabled, and
:ref:`glossary-IPv6` address is present.
