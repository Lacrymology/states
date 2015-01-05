Pillar
======

Consult https://www.kernel.org/doc/Documentation/sysctl/ for more information.

Optional
--------

sysctl
~~~~~~

Dictionary of key-value of parameters to configure kernel.

Default: do not change kernel configuration (``{}``).

Conditional
-----------

All below pillar keys have default ``False``, which means not change
its respective parameter of kernel.

sysctl:fs.file-max
~~~~~~~~~~~~~~~~~~

The maximum number of file-handles that the Linux kernel will allocate.
