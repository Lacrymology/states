.. include:: /doc/include/add_pillar.inc

- :doc:`/mongodb/doc/index` :doc:`/mongodb/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Optional
--------

graylog2:ssl
~~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False``.

graylog2:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False``.

graylog2:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See uwsgi/doc/instance.rst for more details

graylog2:smtp
~~~~~~~~~~~~~

This is configuration to allow Graylog2 to send email.
Please see `doc/pillar.rst` for details.

Default: value of ``smtp`` pillar key.

Mandatory
---------

Example::

  graylog2:
    hostnames:
     - graylog2.example.com
    workers: 2

graylog2:hostnames
~~~~~~~~~~~~~~~~~~

List of HTTP hostname.

graylog2:workers
~~~~~~~~~~~~~~~~

Number of uWSGI worker that will run the webapp.
