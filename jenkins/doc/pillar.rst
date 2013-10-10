
Pillar
======

Mandatory
---------

Example:

  jenkins:
    hostnames:
      - ci.example.com

jenkins:hostnames
~~~~~~~~~~~~~~~~~~

List of HTTP hostnames that ends in jenkins webapp.

Optional
--------

Example:

  jenkins:
    ssl: sologroup
    ssl_redirect: True

jenkins:ssl
~~~~~~~~~~~

Name of the SSL key to use for HTTPS.

Default: ``False`` by default of that pillar key.

jenkins:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

If set to True and SSL is turned on, this will force all HTTP traffic to be
redirected to HTTPS.

Default: ``False`` by default of that pillar key.
