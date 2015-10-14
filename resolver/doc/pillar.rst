Pillar
======

.. include:: /doc/include/add_pillar.inc

Optional
--------

.. _pillar-resolver-nameservers:

resolver:nameservers
~~~~~~~~~~~~~~~~~~~~

List of name servers used for configure :doc:`index`.
These will be the first name servers used when resolving :ref:`glossary-DNS`

Default: insert no name server (``[]``).

.. _pillar-resolver-append:

resolver:append
~~~~~~~~~~~~~~~

List of name servers used for appending to configure :doc:`index`.
These will be the last resorts when resolving :ref:`glossary-DNS`.

Default: append no name server (``[]``).
