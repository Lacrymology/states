..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Clamav
======

Introduction
------------

Clam AntiVirus (ClamAV) is a free and open-source, cross-platform antivirus
software tool-kit able to detect many types of malicious software, including
viruses.  One of its main uses is on mail servers as a server-side email virus
scanner

.. http://en.wikipedia.org/wiki/Clam_AntiVirus

.. note::

  If Clamav is used to filter mail for virus, look
  :doc:`/mail/server/doc/index` to setup a full-stack mail system.

.. _clamav-freshclam:

Freshclam
---------

FreshClam_ :ref:`glossary-daemon` come with :doc:`index`
and is used to update it's virus database.

This is as much important as :doc:`index` itself.

Link
----

* `Clamav page <http://www.clamav.net>`_
* `Clamav Wikipedia page <http://en.wikipedia.org/wiki/Clam_AntiVirus>`_

Related Formulas
----------------

* :doc:`/apt/doc/index`
* :doc:`/bash/doc/index`
* :doc:`/cron/doc/index`
* :doc:`/rsyslog/doc/index`

Content
-------

.. toctree::
    :glob:

    *

.. _FreshClam: https://packages.debian.org/sid/clamav-freshclam
