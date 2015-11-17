========
 Pillar
========

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/git/doc/index` :doc:`/git/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/postgresql/doc/index` :doc:`/postgresql/doc/pillar`
- :doc:`/ssh/server/doc/index` :doc:`/ssh/server/doc/pillar`

.. warning::

   See :ref:`pillar-ssh-server-extra_configs`.

Mandatory
=========

Example::

  gitlab:
    hostnames:
      - gitlab.axmple.com
    admin:
      password: mypass
    db_key_base: superlongkey

.. _pillar-gitlab-hostnames:

gitlab:hostnames
----------------

.. include:: /nginx/doc/hostnames.inc

Example: ``__salt__['network.ip_addrs']('eth0')[0]``

.. _pillar-gitlab-admin-password:

.. warning::

   Consider destroy Administrator account after created an another
   admin.

gitlab:admin:password
---------------------

Password for :doc:`index` Administrator account.

Example: ``'123456789'``

.. note::

    If multiple ports are set and ``22`` is set in
    pillar key :ref:`pillar-ssh-server-ports` (see :doc:`/ssh/server/doc/index`)
    , use ``22`` as preferred value.
    Otherwise use the only value provided. In that case, user
    will need to specify their port in :doc:`/git/doc/index` config file.

.. _pillar-gitlab-db_key_base:

gitlab:db_key_base
------------------

Used to encrypt for variables, required to access variables stored in database,
use at least 30 random characters.

Optional
========

Example::

  gitlab:
    admin:
      email: admin@example.com
    workers: 2
    idle: 300
    cheaper: 1
    timeout: 60
    ssl: example_com
    email_from: support@example.com
    restricted_visibility_levels: public
    visibility_level: private
    max_size: 5242880
    commit_timeout: 10
    db:
      password: randompassword

.. _gitlab-admin-email:

gitlab:admin:email
------------------

The email address for the default Administrator account.
This can be used to login at the first time after installing.

Default: Use the value of :ref:`pillar-smtp-from` pillar key (``False``).

.. _pillar-gitlab-commit_timeout:

gitlab:commit_timeout
---------------------

Git timeout to read a commit, in seconds

Default: abort if can't read a commit in ``30`` seconds.

.. _pillar-gitlab-max_size:

gitlab:max_size
---------------

Max size of a :doc:`/git/doc/index` object (e.g. a commit), in bytes.
This value can be increased if you have very large commits

Default: max size of a :doc:`/git/doc/index` object is 5 megabytes
(``5242880``).

.. _pillar-gitlab-ssl:

gitlab:ssl
----------

.. include:: /nginx/doc/ssl.inc

.. _pillar-gitlab-ssl_redirect:

gitlab:ssl_redirect
-------------------

.. include:: /nginx/doc/ssl_redirect.inc

.. |deployment| replace:: gitlab

.. _pillar-gitlab-smtp:

gitlab:smtp
-----------

.. include:: /mail/doc/smtp.inc

.. _pillar-gitlab-smtp-from:

gitlab:smtp:from
----------------

The address that will appear in the "From:" field of the email sent by
:doc:`index`.

Default: Use the value of :ref:`pillar-smtp-from` (``False``).

.. _pillar-gitlab-db-password:

gitlab:db:password
------------------

.. include:: /postgresql/doc/password.inc

gitlab:incoming_email
---------------------

:ref:`glossary-imap` account information to receive incoming emails.

Format::

  gitlab:
    incoming_email:
      address: "incoming+%{key}@gitlab.example.com"
      user: incoming
      password: secretpass
      host: "gitlab.example.com"
      port: 143
      ssl: false
      start_tls: false

The email address including the ``%{key}`` placeholder that will be replaced to
reference the item being replied to. If not specified, it will be guess from
user. For example, if user is ``gitlab@example.com``, the address will be
``gitlab+%{key}@example.com``.

Default: don't receive incoming email (``False``).
