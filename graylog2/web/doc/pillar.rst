Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Mandatory
---------

Example::

  graylog2:
    hostnames:
     - graylog2.example.com

.. _pillar-graylog2-hostnames:

graylog2:hostnames
~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

.. _pillar-graylog2-ssl:

graylog2:ssl
~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-graylog2-ssl_redirect:

graylog2:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

.. _pillar-graylog2-smtp:

graylog2:smtp
~~~~~~~~~~~~~

.. include:: /mail/doc/smtp.inc

.. _pillar-graylog2-web-application_secret:

graylog2:web:application_secret
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The secret key is used to secure cryptographics functions.

Default: randomly generated (``False``).

.. _pillar-graylog2-web-user:

graylog2:web:user
~~~~~~~~~~~~~~~~~

The Unix user (UID) who will run :doc:`index`.

Default: ``graylog2-ui``

.. _pillar-graylog2-web-heap_size:

graylog2:web:heap_size
~~~~~~~~~~~~~~~~~~~~~~

The size of `heap
<http://en.wikipedia.org/wiki/Java_virtual_machine#Heap>`_ give for
JVM.

Default: use JVM default (``False``).
