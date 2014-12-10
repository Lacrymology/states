Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Conditional
-----------

Example::

  crontab_hour: 6

.. _pillar-crontab_hour:

crontab_hour
~~~~~~~~~~~~

Each days cron launch a daily group of tasks, they are located in
``/etc/cron.daily/``.

This is the time of the day when they're executed.

Default: ``6``. Six hours in the morning, local time.

The hour can be from ``0`` to ``23``. Any invalid entry can lead to cron to not
``run-parts`` properly ``/etc/cron.*``.

Only used if :ref:`pillar-__test__` is ``False``.
