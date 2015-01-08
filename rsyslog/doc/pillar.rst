Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`

Optional
--------

.. _pillar-rsyslog-tcp:

rsyslog:tcp
~~~~~~~~~~~

Use :ref:`glossary-TCP` for transfering log to remote destination.

Default: Use :ref:`glossary-UDP` (``False``).

.. _pillar-rsyslog-rotate:

rsyslog:rotate
~~~~~~~~~~~~~~

The number of days the log file will be rotated before being removed.

Default: ``14`` days.
