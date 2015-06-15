.. Copyright (c) 2013, Bruno Clermont
.. All rights reserved.
..
.. Redistribution and use in source and binary forms, with or without
.. modification, are permitted provided that the following conditions are met:
..
..     1. Redistributions of source code must retain the above copyright notice,
..        this list of conditions and the following disclaimer.
..     2. Redistributions in binary form must reproduce the above copyright
..        notice, this list of conditions and the following disclaimer in the
..        documentation and/or other materials provided with the distribution.
..
.. Neither the name of Bruno Clermont nor the names of its contributors may be used
.. to endorse or promote products derived from this software without specific
.. prior written permission.
..
.. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
.. AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
.. THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
.. PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
.. BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
.. CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
.. SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
.. INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
.. CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
.. ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
.. POSSIBILITY OF SUCH DAMAGE.

.. include:: /doc/include/add_pillar.inc

- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/mariadb/server/doc/index` :doc:`/mariadb/server/doc/pillar`

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

wordpress:hostnames
~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

wordpress:title
~~~~~~~~~~~~~~~

Site's title.

wordpress:username
~~~~~~~~~~~~~~~~~~

Administrator's username.

wordpress:admin_password
~~~~~~~~~~~~~~~~~~~~~~~~

Administrator's password.

wordpress:email
~~~~~~~~~~~~~~~

Administrator's email.

Optional
--------

Example::

  debug: False
  wordpress:
    password: dbpassword
    public: 1
    mysql_variant: mariadb
    ssl: False
    ssl_redirect: True
    workers: 2
    cheaper: 1
    timeout: 60
    idle: 300

debug
~~~~~

Enable Debug logging to the ``/wp-content/debug.log`` file

wordpress:password
~~~~~~~~~~~~~~~~~~

:doc:`/mariadb/doc/index` user password.

wordpress:mysql_variant
~~~~~~~~~~~~~~~~~~~~~~~

Variation of the MySQL that you use.

Default: ``MariaDB``.

wordpress:public
~~~~~~~~~~~~~~~~

Site appear in search engines.

Default: ``1`` (yes).

wordpress:ssl
~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

wordpress:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

wordpress:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /uwsgi/doc/pillar.inc
