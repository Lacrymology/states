Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`

Mandatory
---------

Example::

  jenkins:
    hostnames:
      - ci.example.com

.. _pillar-jenkins-hostnames:

jenkins:hostnames
~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

Example::

  jenkins:
    ssl: example_com
    ssl_redirect: True

.. _pillar-jenkins-ssl:

jenkins:ssl
~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-jenkins-ssl_redirect:

jenkins:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc
