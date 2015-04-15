Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`

.. |deployment| replace:: geminabox

Mandatory
---------

geminabox:hostnames
~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

.. _pillar-geminabox-ssl:

geminabox:ssl
~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

geminabox:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

.. _pillar-geminabox-username:

geminabox:username
~~~~~~~~~~~~~~~~~~

:doc:`index` username for authentication.

Default: turn off authentication (``False``).

.. _pillar-geminabox-password:

geminabox:password
~~~~~~~~~~~~~~~~~~

:doc:`index` password for authentication.

Default: turn off authentication (``False``).

.. warning::

   Authentication is only enable if both :ref:`pillar-geminabox-username` and
   :ref:`pillar-geminabox-password` are defined.

geminabox:proxy_mode
~~~~~~~~~~~~~~~~~~~~

Enable :doc:`index` proxy feature to pull gems from `<rubygems.org>`_ that it
does not currently have.

Default: disable proxy mode (``False``).

.. include:: /uwsgi/doc/pillar.inc
