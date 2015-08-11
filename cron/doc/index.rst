..
   Author: Bruno Clermont <bruno@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Cron
====

Introduction
------------

The software utility :doc:`index`
is a time-based job scheduler in Unix-like computer
operating systems. People who set up and maintain software environments use
:doc:`index` to schedule jobs (commands or shell scripts)
to run periodically at fixed times, dates, or intervals.

.. http://en.wikipedia.org/wiki/Cron

Format
------

A crontab file has five fields for specifying day, date and time followed by
the command to be run at that interval::

  *     *     *     *     *        command to be executed
  -     -     -     -     -
  |     |     |     |     |
  |     |     |     |     +----- day of week (0 - 6) (Sunday=0)
  |     |     |     +------- month (1 - 12)
  |     |     +--------- day of month (1 - 31)
  |     +----------- hour (0 - 23)
  +------------- min (0 - 59)

``*`` in the value field above means all legal values as in braces for that
column. The value column can have a ``*`` or a list of elements separated by
commas. An element is either a number in the ranges shown above or two numbers
in the range separated by a hyphen (meaning an inclusive range).

Links
-----

* `Wikipedia Cron page <http://en.wikipedia.org/wiki/Cron>`_
* `Ubuntu CronHowto page <https://help.ubuntu.com/community/CronHowto>`_

Related Formulas
----------------

* :doc:`/apt/doc/index`
* :doc:`/bash/doc/index`
* :doc:`/rsyslog/doc/index`

Content
-------

.. toctree::
    :glob:

    *
