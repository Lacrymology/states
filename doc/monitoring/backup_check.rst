.. This file simply imports the code from /backup/server/nrpe/check.py

Backup server check
===================

This is the source for ``/backup/server/nrpe/check.py`` which will be
installed by the formula ``backup.server.nrpe`` at
``/usr/lib/nagios/plugins/check_backups.py``. It is of interest as an
example of a nagios plugin that defines a custom
``nagiosplugin.Context`` subclass.

.. py:module:: backup.server.nrpe.check

.. literalinclude:: /backup/server/nrpe/check.py
   :language: python
   :linenos:
