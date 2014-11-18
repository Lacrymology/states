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

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/pip/doc/index` :doc:`/pip/doc/pillar`
- if ``sentry:ssl`` is defined :doc:`/ssl/doc/index` :doc:`/ssl/doc/pillar`

Mandatory
---------

Example::

  shinken:
    graphite_url: http://graphite.example.com
    users:
      <username>:
        email:
        password:
    architecture:
      broker:
      arbiter:
      scheduler:
      reactionner:
      poller:
        id:
    hostname:
      - shinken.example.com

shinken:graphite_url
~~~~~~~~~~~~~~~~~~~~

:doc:`/graphite/doc/index` address.
Should be one value in :doc:`/graphite/doc/pillar` ``graphite:hostnames``.

shinken:users
~~~~~~~~~~~~~

List contact users.
Please replace <username> by real username.

shinken:poller_max_fd
~~~~~~~~~~~~~~~~~~~~~

Maximum number of file descriptors poller can allocate.

Default: ``16384``.

shinken:<username>:email
~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` user's email

shinken:<username>:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` user's password

shinken:architecture:broker
~~~~~~~~~~~~~~~~~~~~~~~~~~~

shinken:architecture:arbiter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

shinken:architecture:scheduler
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

shinken:architecture:reactionner
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

shinken:architecture:poller:id
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

shinken:hostnames
~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

Example::

  shinken:
    ssl: False
    ssl_redirect: False

shinken:ssl
~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

shinken:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

shinken:log_level
~~~~~~~~~~~~~~~~~

Define level of logging.

Default: ``INFO``.
