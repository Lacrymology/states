{#-
Rsync: A file-copying tool
=============================

Mandatory Pillar
----------------

Optional Pillar
---------------

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
-#}
rsync:
  pkg:
    - installed
  file:
    - managed
    - name: /etc/init/rsync.conf
    - template: jinja
    - source: salt://rsync/upstart.jinja2
    - user: root
    - group: root
    - mode: 440
    - require:
      - pkg: rsync
  service:
    - running
    - enable: True
    - watch:
      - file: rsync
      - file: /etc/rsyncd.conf
      - pkg: rsync

/etc/rsyncd.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 440
    - template: jinja
    - source: salt://rsync/config.jinja2
    - require:
      - pkg: rsync
