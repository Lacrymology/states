Monitor
=======

Mandatory
---------

.. |deployment| replace:: graylog2.web

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``graylog2.web``.

.. include:: /nginx/doc/monitor.inc

graylog2_web_procs
~~~~~~~~~~~~~~~~~~

.. include:: /nrpe/doc/check_procs.inc

Expect status: exactly one :doc:`/graylog2/doc/index` web daemon process
running.

graylog2_web_port
~~~~~~~~~~~~~~~~~

Monitor :doc:`index` web port :ref:`glossary-TCP` ``9000``.

graylog2_web_http
~~~~~~~~~~~~~~~~~

Monitor :doc:`index` web :ref:`glossary-HTTP`
:ref:`glossary-TCP` ``9000``.

Expect return code: ``303 See Other`` (redirect to login page).

Optional
--------

Only use if :ref:`pillar-graylog2-ssl` is defined.

.. include:: /nginx/doc/monitor_ssl.inc

Only use if :ref:`pillar-ip_version` is set to ``ipv6`` or ``both``.

.. include:: /nginx/doc/monitor_ipv6.inc
