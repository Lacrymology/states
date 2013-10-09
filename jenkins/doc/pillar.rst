
Pillar
======

Mandatory
---------

jenkins:hostnames
~~~~~~~~~~~~~~~~~~

List of HTTP hostnames that ends in jenkins webapp.

Optional
--------

jenkins:ssl
~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

jenkins:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Example::

  jenkins:
    hostnames:
      - ci.example.com
