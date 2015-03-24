..
   Author: Viet Hung Nguyen <hvn@robotinfra.com>
   Maintainer: Viet Hung Nguyen <hvn@robotinfra.com>

RoundCube
=========

Introduction
------------

Roundcube_ is a web-based :ref:`glossary-imap` email client. Roundcube_'s most
prominent feature
is the pervasive use of Ajax technology to present a more fluid and responsive
user interface than that of traditional webmail clients. After about two years
of development, the first stable release of Roundcube_ was announced in early
2008.

.. http://en.wikipedia.org/wiki/Roundcube - 2015-01-23

.. note::

  Consult :doc:`/mail/doc/index` for setting up a full-stack mail system.

Links
-----

* `Roundcube Homepage <http://roundcube.net/>`_
* `Wikipedia <http://en.wikipedia.org/wiki/Roundcube>`_


Related Formulas
----------------

To works properly, Roundcube_ need to have installed:

- :doc:`/postfix/doc/index`
- :doc:`/openldap/doc/index`
- :doc:`/dovecot/doc/index`

On the same **or** separate host, for this reason they can't be included by
other formulas. Roles and :doc:`pillar` need to define expected
mail architecture.

Content
-------

.. toctree::
    :glob:

    *

.. _RoundCube: http://roundcube.net
