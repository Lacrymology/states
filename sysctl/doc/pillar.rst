Pillar
======

Optional
--------

.. _pillar-sysctl:

sysctl
~~~~~~

Dictionary of key-value of parameters to configure kernel.

Default: do not change kernel configuration (``{}``).

Conditional
-----------

All below pillar keys have default ``False``, which means not change
its respective parameter of kernel.

.. _pillar-sysctl-fs-file-max:

sysctl:fs.file-max
~~~~~~~~~~~~~~~~~~

The maximum number of file-handlers that the Linux kernel will allocate.

.. _pillar-sysctl-{{ key }}:

sysctl:{{ key }}
~~~~~~~~~~~~~~~~

Kernel configuration value to set for {{ key }}.
