Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`

Mandatory
---------

.. _pillar-apt_cache-hostnames:

apt_cache:hostnames
~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

.. _pillar-apt_cache-ssl:

apt_cache:ssl
~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-apt_cache-ssl_redirect:

apt_cache:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

.. _pillar-apt_cache-admin_username:

apt_cache:admin_username
~~~~~~~~~~~~~~~~~~~~~~~~

Username of :doc:`index` administrator.

Default: turn off authentication (``False``).

.. _pillar-apt_cache-admin_password:

apt_cache:admin_password
~~~~~~~~~~~~~~~~~~~~~~~~

Password of :doc:`index` administrator.

Default: turn off authentication (``False``).

.. warning::

   Authentication is only enable if both :ref:`pillar-apt_cache-admin_username`
   and :ref:`pillar-apt_cache-admin_password` are defined.
