Pillar
======

Optional
--------

Example::

  rsync:
   attribute: value
   'other attrib': other value
   module_name:
      'mod attrib 2': value
      attrib: value
    module_name2:
      ...

Attributes and values is mapped to rsync daemon's attributes and values. If
attribute contains space, wrap quotes about it. All attributes and values
are available here http://rsync.samba.org/documentation.html.

Example::

  rsync:
    'max connections': 4
    documents:
      path: /home/foo/docs
      comment: many serious documents...
      'read only': true
