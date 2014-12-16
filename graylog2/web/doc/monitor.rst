Monitor
=======

.. |deployment| replace:: graylog2.web

.. warning::

   In this document, when refer to a pillar key ``pillar_prefix``
   means ``graylog2.web``.

.. include:: /nginx/doc/monitor.inc

graylog2_web_procs
------------------

.. include:: /nrpe/doc/check_procs.inc

Expect status: exactly one :doc:`/graylog2/doc/index` web daemon process running.

graylog2_web_port
-----------------

Monitor :doc:`/graylog2/web/doc/index` web port ``9000/tcp``.

graylog2_web_http
-----------------

Monitor :doc:`/graylog2/web/doc/index` web HTTP ``9000/tcp``.

Expect return code: ``303 See Other`` (redirect to login page).

Conditional
-----------

Only use if :ref:`pillar-graylog2-ssl` is turned on.

.. include:: /nginx/doc/monitor_ssl.inc
