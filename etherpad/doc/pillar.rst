Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/postgresql/doc/index` :doc:`/postgresql/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Mandatory
---------

Example::

  etherpad:
    hostnames:
      - pad.example.com
    apikey: blahlabhlabh

.. _pillar-etherpad-hostnames:

etherpad:hostnames
~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

.. _pillar-etherpad-apikey:

etherpad:apikey
~~~~~~~~~~~~~~~

The secret key for access to API.

Optional
--------

Example::

  etherpad:
    ssl: microsigns
    ssl_redirect: True
    database:
      name: etherpad
      username: etherpad
      password: psqluserpass
      host: localhost
    require_session: False
    require_authentication: False
    require_authorization: False
    users:
      user1:
        password: 123123123
        admin: True
      user2:
        password: 321321321
      {{ username }}:
        password: {{ userpass }}
        admin: True
    apikey: 23jlLJKHJSK9saf92hasajJHAds==
    default_pad_text: Welcome to Pad
    secret_url: noonecanguessthatlongURL

.. _pillar-etherpad-db-username:

etherpad:db:username
~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/username.inc

Default: ``etherpad``.

.. _pillar-etherpad-db-name:

etherpad:db:name
~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/name.inc

Default: ``etherpad``.

.. _pillar-etherpad-db-password:

etherpad:db:password
~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/password.inc

.. _pillar-etherpad-db-host:

etherpad:db:host
~~~~~~~~~~~~~~~~

:doc:`/postgresql/doc/index` server address.

Default: ``localhost``.

.. _pillar-etherpad-ssl:

etherpad:ssl
~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-etherpad-ssl_redirect:

etherpad:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

.. _pillar-etherpad-require_session:

etherpad:require_session
~~~~~~~~~~~~~~~~~~~~~~~~

Users must have a session to access pads. This effectively allows only group
pads to be accessed.

Default: don't require session (``False``).

.. _pillar-etherpad-require_authentication:

etherpad:require_authentication
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This setting is used if you require authentication of all users.
Note: ``/admin`` always requires authentication.

Default: don't require authentication (``False``).

.. _pillar-etherpad-require_authorization:

etherpad:require_authorization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Require authorization by a module, or a user with ``admin: True`` set.

Default: don't require authorization (``False``).

.. _pillar-etherpad-users:

etherpad:users
~~~~~~~~~~~~~~

A dictionary of users.

Default: don't create any user (``{}``).

.. _pillar-etherpad-default_pad_text:

etherpad:default_pad_text
~~~~~~~~~~~~~~~~~~~~~~~~~

The default text of a pad.

Default: does not use default text (``False``).

.. _pillar-etherpad-restrict_referer:

etherpad:restrict_referer
~~~~~~~~~~~~~~~~~~~~~~~~~

Regular Expression for referer :ref:`glossary-URL` restriction. When you want
block direct access to :doc:`index`.

Example: ``^(.*)(sometext|othertex)(.*)$``

Default: allow access from all referers, (``False``).

.. _pillar-etherpad-title:

etherpad:title
~~~~~~~~~~~~~~

:doc:`index` title display in browser.

Default: ``Etherpad``.

.. _pillar-etherpad-listen_port:

etherpad:listen_port
~~~~~~~~~~~~~~~~~~~~

:doc:`index` listen :ref:`glossary-TCP` port.

Default: listen on port ``9001``.

.. _pillar-etherpad-secret_url:

etherpad:secret_url
~~~~~~~~~~~~~~~~~~~

If set, only allow access :doc:`index` by this :ref:`glossary-URL`,
don't allow access directly.

For example, if :ref:`pillar-etherpad-hostnames` is ``['example_pad.com']`` and
:ref:`pillar-etherpad-secret_url` is ``'top_secret'``, we can only use
:doc:`index` with :ref:`glossary-URL`: ``example_pad.com/top_secret``, request
to ``example_pad.com`` will return ``403 error``

Example: ``'a_secret_string'``

Default: Allow to access directly via domain, without an secret
:ref:`glossary-URL` (``False``).

Conditional
-----------

.. _pillar-etherpad-users-username:

etherpad:users:{{ username }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Username of user who uses :doc:`index`.

Used only if :ref:`pillar-etherpad-users` is defined.

.. _pillar-etherpad-users-username-admin:

etherpad:users:{{ username }}:admin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Grant admin access for this user.

Default: don't make this user a admin, (``False``).

.. _pillar-etherpad-users-username-password:

etherpad:users:{{ username }}:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Password of this user.

Used only if :ref:`pillar-etherpad-users-username` is defined.
