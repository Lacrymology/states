.. Copyright (c) 2013, Lam Dang Tung
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
.. Neither the name of Lam Dang Tung nor the names of its contributors may be used
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

Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/git/doc/index` :doc:`/git/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`
- :doc:`/postgresql/doc/index` :doc:`/postgresql/doc/pillar`
- :doc:`/redis/doc/index` :doc:`/redis/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Mandatory
---------

Example::

  discourse:
    hostnames:
      - discourse.example.com

discourse:hostnames
~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

Example::

  discourse:
    upload_size: 2
    smtp:
      enabled: True
    ssl: microsigns
    ssl_redirect: True
    database:
      name: discourse
      username: discourse
      password: psqluserpass
    workers: 2
    cheaper: 1
    timeout: 60
    idle: 300

discourse:db:username
~~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/username.inc

Default: ``discourse``.

discourse:db:name
~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/name.inc

Default: ``discourse``.

discourse:db:password
~~~~~~~~~~~~~~~~~~~~~

.. include:: /postgresql/doc/password.inc

discourse:upload_size
~~~~~~~~~~~~~~~~~~~~~

Max file size for upload to server. In megabyte.

Default: ``2`` megabytes.

discourse:ssl
~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

discourse:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

discourse:(workers|cheapers|idle|timeout)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /uwsgi/doc/pillar.inc

discourse:smtp
~~~~~~~~~~~~~~

.. include:: /mail/doc/smtp.inc
