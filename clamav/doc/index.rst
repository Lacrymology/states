..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Clamav
======

More can be find at official `Clamav page <http://www.clamav.net>`_.

.. note::

  If Clamav is used to filter mail for virus, look :doc:`/mail/server/doc/index`
  to setup a full-stack mail system.

.. _clamav-freshclam:

Freshclam
---------

`FreshClam`_ :ref:`glossary-daemon` come with Clamav and is used to update it's
virus database.

This is as much important as Clamav itself.

.. toctree::
    :glob:

    *

.. _FreshClam: https://packages.debian.org/sid/clamav-freshclam