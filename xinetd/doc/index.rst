xinetd
======

Introduction
------------

xinetd is a powerful replacement for inetd.

Original site: http://www.xinetd.org

xinetd has access control mechanisms, extensive logging capabilities,
the ability to make services available based on time, can place limits
on the number of servers that can be started, and has deployable
defence mechanisms to protect against port scanners, among other
things.

Usage
-----

Create a file within ``/etc/xinetd.d`` directory and extend service
``xinetd`` to watch it.

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

.. toctree::
    :glob:

    *
