Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/nginx/doc/index` :doc:`/nginx/doc/pillar`

Mandatory
---------

Example::

  syncthing:
    hostnames:
      - syncthing.example.com
    password: mypassword

.. _pillar-syncthing-hostnames:

syncthing:hostnames
~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/hostnames.inc

syncthing:password
~~~~~~~~~~~~~~~~~~

Password for :doc:`index` ``admin`` account.

Optional
--------

Example::

  syncthing:
    ssl: syncthing.example.com
    ssl_redirect: True

.. _pillar-syncthing-ssl:

syncthing:ssl
~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl.inc

.. _pillar-syncthing-ssl_redirect:

syncthing:ssl_redirect
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /nginx/doc/ssl_redirect.inc

.. _pillar-syncthing-folders:

syncthing:folders
~~~~~~~~~~~~~~~~~

Folders to share with other devices.

Example::

  synthing:
    folders:
      test:
        path: /usr/local/test # optional, default to /var/lib/syncthing/test
        readonly: True # optional, default to False
        devices:
          - device-1
          - device-2

Devices attribute must be a list of devices define in
:ref:`pillar-syncthing-devices`.

:doc:`index` formula implicitly defines a folder with following config::

  syncthing:
    folders:
      default:
        path: /var/lib/syncthing/Sync
        devices:
          - {{ minion_id }}

Default: share no folder (``{}``).

.. _pillar-syncthing-devices:

syncthing:devices
~~~~~~~~~~~~~~~~~

Known devices to share resources with.

Example::

  syncthing:
    devices:
      laptop:
        id: MFZWI3D-BONSGYC-YLTMRWG-C43ENR5-QXGZDMM-FZWI3DP-BONSGYY-LTMRWAD
        compression: always # optional, default to "metadata"
        introducer: True # optional, default to False

:doc:`index` formula implicitly defines a device with following config::

  syncthing:
    devices:
      {{ grains["id"] }}:
        id: {{ own syncthing id }}

Default: share resources with no device (``{}``).
