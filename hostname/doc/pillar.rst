Pillar
======

Optional
--------

Example::

  hostname:
    present:
      1.2.3.4: example.com
    absent:
      2.3.4.5: example.net

.. _pillar-hostname-present:

hostname:present
~~~~~~~~~~~~~~~~

Dictionary of IP maps to list of hostnames that this formula will
ensure to be present on the machine.

Default: no host present (``{}``).

.. _pillar-hostname-absent:

hostname:absent
~~~~~~~~~~~~~~~

Dictionary of IP maps to list of hostnames that this formula will
ensure them to be absent from the machine.

Default: no host to be absent (``{}``).
