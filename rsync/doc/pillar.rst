Pillar
======

Optional
--------

Example::

  rsync:
    limit_per_ip: 1
    global_settings:
      attribute: value
      'other attrib': other value
    modules:
      module_name:
        'mod attrib 2': value
        attrib: value
      module_name2:
        ...

.. _pillar-rsync-limit_per_ip:

rsync:limit_per_ip
~~~~~~~~~~~~~~~~~~

Takes an integer or "UNLIMITED" as an argument.
This specifies the maximum instances of this service per source IP
address.

Default: ``'"UNLIMITED"'``.

.. _pillar-rsync-global_settings:

rsync:global_settings
~~~~~~~~~~~~~~~~~~~~~

Attributes and values is mapped to :doc:`index` daemon's attributes and
values. If attribute contains space, wrap quotes about it. All attributes and
values are `available here <http://rsync.samba.org/documentation.html>`_.

Default: use default settings (``{}``).

Example::

  rsync:
    global_settings:
      'max connections': 4

.. _pillar-rsync-modules:

rsync:modules
~~~~~~~~~~~~~

Dictionay contains information of all :doc:`index` modules.

Default: don't use any module (``{}``).

Example::

  rsync:
    modules:
      documents:
        path: /home/foo/docs
        comment: many serious documents...
        'read only': true
