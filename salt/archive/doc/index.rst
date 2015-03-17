..
   Author: Bruno Clermont <bruno@robotinfra.com>
   Maintainer: Diep Pham <favadi@robotinfra.com>

Salt Archive Server
===================

Introduction
------------

Installing the latest version of remote depdencies often causes problems:

- Network issue
- Latency
- Can be quite slow sometimes
- Remote mirror is temporarly unavailable (Not depending on the pypi.python.org,
  github.com, etc)

This can be use to internally mirror every files which are use to deploy states.

The major benifit to use this is for testing. As tests required the same files
to be download over and over, it make the entire test run faster.

Installation
------------

Run this formula will create a ``/var/lib/salt_archive/`` to hold the files.

The initial application of this formula will take a while as it
:doc:`/rsync/doc/index` the entire content of :ref:`pillar-salt_archive-source`
:doc:`/rsync/doc/index` server.

Once done you can connect to :ref:`pillar-salt_archive-hostnames` to see all mirrored
files.

.. toctree::
    :glob:

    *
