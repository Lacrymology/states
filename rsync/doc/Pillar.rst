Pillar
======

Mandatory 
---------

Optional
--------

rsync:
  attribute: value
  'other attrib': other value
  module_name:
    'mod attrib 2': value
    attrib: value
  module_name2:
    ...

Attributes and values is mapping to rsync daemon's attributes and values

Example:

  rsync:
    'max connections': 4
    documents:
      path: /home/foo/docs
      comment: many serious documents...
      'read only': true
