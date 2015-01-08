Usage
=====

Create a file with ``file.managed`` in ``/etc/xinetd.d`` directory and extend
service ``xinetd`` to watch it.

Example::

  include:
    - xinetd

  /etc/xinetd.d/rsync:
    file:
      - managed
      - source: salt://rsync/xinetd.jinja2
      - template: jinja
      - mode: 440
      - user: root
      - group: root
      - require:
        - file: /etc/xinetd.d
      - watch_in:
        - service: xinetd
