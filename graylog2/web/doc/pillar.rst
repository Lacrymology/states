.. include:: /doc/include/add_pillar.inc

- :doc:`/mongodb/doc/index` :doc:`/mongodb/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Mandatory
---------

Example::

  graylog2:
    hostnames:
     - graylog2.example.com

graylog2:hostnames
~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

graylog2:ssl
~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

graylog2:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

graylog2:smtp
~~~~~~~~~~~~~

.. include:: /mail/doc/smtp.inc

graylog2:application_secret
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The secret key is used to secure cryptographics functions.

Default: random generated

graylog2:web:user
~~~~~~~~~~~~~~~~~

The Unix user (UID) who will run graylog2 web interface.

Default: ``graylog2-ui``


