Pillar
======

Example::

  redirect:
    ssl: example.com
    map:
      - hostnames:
          - example.com
        ssl: True
        destination: https://www.example.com
        keep_request: True
      - hostnames:
          - blog.example.com
        destination: https://example.blogger.com/

Mandatory
---------

.. _pillar-redirect-map:

redirect:map
~~~~~~~~~~~~

List of all redirections to perform as a dictionary with the following keys:

- ``hostnames``: list of hostname to redirect
- ``ssl``: if set to ``True`` (not the default) it listen to http and https with
   the key in :ref:`pillar-redirect-ssl`..
- ``destination``: the complete :ref:`glossary-URL` where redirect send to
- ``keep_request``: if set to ``True`` (not default), it append to the
  :ref:`glossary-URL` the actual request.

Optional
--------

.. _pillar-redirect-ssl:

redirect:ssl
~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc
