Pillar
======

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
        - integration-0
      arbiter:
        - integration-0
      scheduler:
        - integration-0
      reactionner:
        - integration-0
      poller:
        integration-0: all
    hostname:
      - shinken.example.com

.. _pillar-shinken-graphite_url:

shinken:graphite_url
~~~~~~~~~~~~~~~~~~~~

:doc:`/graphite/doc/index` address.
Should be one value in :ref:`pillar-graphite-hostnames`.

.. _pillar-shinken-users:

shinken:users
~~~~~~~~~~~~~

List contact users.
Please replace {{ username }} by real username.

.. _pillar-shinken-username-email:

shinken:users:{{ username }}:email
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` user's email

shinken:users:{{ username }}:password
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:doc:`index` user's password

.. _pillar-shinken-architecture-broker:

shinken:architecture:broker
~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of :ref:`shinken-broker` IDs.

.. _pillar-shinken-architecture-arbiter:

shinken:architecture:arbiter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of :ref:`shinken-arbiter` IDs.

.. _pillar-shinken-architecture-scheduler:

shinken:architecture:scheduler
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of :ref:`shinken-scheduler` IDs.

.. _pillar-shinken-architecture-reactionner:

shinken:architecture:reactionner
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of :ref:`shinken-reactionner` IDs.

.. _pillar-shinken-architecture-poller:

shinken:architecture:poller
~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of :ref:`shinken-poller` IDs.

.. _pillar-shinken-architecture-poller-id:

shinken:architecture:poller:{{ id }}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Data formed as a dictionary: ``id``:``poller_tags``

shinken:hostnames
~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

Optional
--------

Example::

  shinken:
    architecture:
      receiver: 
        - integration-0
    poller_max_fd: 16384
    ssl: False
    ssl_redirect: False
    log_level: DEBUG
    nrpe:
      timeout: 30

.. _pillar-shinken-architecture-receiver:

shinken:architecture:receiver
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

List of :ref:`shinken-receiver` IDs.

Default: Unused (empty list ``[]``).

.. _pillar-shinken-poller_max_fd:

shinken:poller_max_fd
~~~~~~~~~~~~~~~~~~~~~

Maximum number of `file descriptors
<http://en.wikipedia.org/wiki/File_descriptor>`_ poller can allocate.

Default: ``16384``.

.. _pillar-shinken-ssl:

shinken:ssl
~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-shinken-ssl_redirect:

shinken:ssl_redirect
~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

.. _pillar-shinken-log_level:

shinken:log_level
~~~~~~~~~~~~~~~~~

Define level of logging.

Default: just log informational messages (``INFO``).
