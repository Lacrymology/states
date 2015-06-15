..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/mysql/server/doc/index` :doc:`/mysql/server/doc/pillar`

Mandatory
---------

Example::

  wordpress:
    hostnames:
      - mydomain.com
    title: My Site
    username: admin
    admin_password: mypassword
    email: admin@mydomain.com

.. _pillar-wordpress-hostnames:

wordpress:hostnames
~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

.. _pillar-wordpress-title:

wordpress:title
~~~~~~~~~~~~~~~

Site's title.

.. _pillar-wordpress-username:

wordpress:username
~~~~~~~~~~~~~~~~~~

Administrator's username.

.. _pillar-wordpress-admin_password:

wordpress:admin_password
~~~~~~~~~~~~~~~~~~~~~~~~

Administrator's password.

.. _pillar-wordpress-admin_email:

wordpress:admin_email
~~~~~~~~~~~~~~~~~~~~~

Administrator's email.

Optional
--------

Example::

  wordpress:
    db:
      password: dbpassword
      user: wp_user
      name: wordpress
    public: 1
    ssl: False
    ssl_redirect: True
    workers: 2
    cheaper: 1
    timeout: 60
    idle: 300

.. _pillar-wordpress-db-password:

wordpress:db:password
~~~~~~~~~~~~~~~~~~~~~

:doc:`/mysql/doc/index` user's password.

Default: auto generated (``None``).

.. _pillar-wordpress-db-name:

wordpress:db:name
~~~~~~~~~~~~~~~~~

:doc:`/mysql/doc/index` database name.

Default: ``wordpress``.

.. _pillar-wordpress-db-username:

wordpress:db:username
~~~~~~~~~~~~~~~~~~~~~

:doc:`/mysql/doc/index` username.

Default: ``wordpress``.

.. _pillar-wordpress-public:

wordpress:public
~~~~~~~~~~~~~~~~

Site appear in search engines.

Default: ``1`` (yes).

.. _pillar-wordpress-ssl:

wordpress:ssl
~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-wordpress-ssl_redirect:

wordpress:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

.. |deployment| replace:: wordpress

.. include:: /uwsgi/doc/pillar.inc
