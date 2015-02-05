Upgrade guide
=============

Tips
----

- Always run salt commands by root user (use ``sudo -sH`` to ensure env set correctly).
- Always run command from ``/`` or ``/root``, not any other directory
  because salt may have problem with setting path.

Steps
-----

Check if all salt components depend on any new package. If so, remove it
from ``test/clean.sls``.

TODO
----
