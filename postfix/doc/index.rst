..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

Postfix
=======

Introduction
------------

Consult :doc:`/mail/doc/index` for setting up a full-stack mail system.

In computing, Postfix is a free and open-source :ref:`glossary-mta` that
routes and delivers electronic mail, intended as an alternative to the widely
used Sendmail :ref:`glossary-mta`. As an :ref:`glossary-smtp` client, Postfix implements a high-performance
parallelized mail-delivery engine.

.. http://en.wikipedia.org/wiki/Postfix_(software) - 2015-01-22

.. warning::

  A server for installing full-stack mail service will need at least 1GB RAM.
  :doc:`/clamav/doc/index` is the component which uses memory the most.

Links
-----

* `Postfix Homepage <http://www.postfix.org/>`_
* `Wikipedia <http://en.wikipedia.org/wiki/Postfix_(software)>`_

Related Formulas
----------------

* :doc:`/apt/doc/index`
* :doc:`/amavis/doc/index`
* :doc:`/dovecot/doc/index`
* :doc:`/ssl/doc/index`

Content
-------

.. toctree::
    :glob:

    *


