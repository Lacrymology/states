Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`

Mandatory
---------

doc:hostnames
~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

.. _pillar-doc-source:

doc:source
~~~~~~~~~~

Location of :doc:`/git/doc/index` documentation repository.

Optional
--------

doc:branch
~~~~~~~~~~

Branch of :ref:`pillar-doc-source` :doc:`/git/doc/index` repository.

Default: use ``'develop'`` branch.

.. _pillar-doc-ssl:

doc:ssl
~~~~~~~

.. include:: /nginx/doc/ssl.inc

doc:ssl_redirect
~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc
