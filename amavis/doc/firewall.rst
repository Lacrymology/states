Firewall
========

.. include:: /doc/include/add_firewall.inc

- :doc:`/spamassassin/doc/index` :doc:`/spamassassin/doc/firewall`

.. warning::

  These 2 ports don't need to be opened unless it's plan to be
  run on a separated hosts as the :doc:`/mail/server/doc/index`. Which is not
  usually the case.

  In case of doubt, don't allow traffic in for them.

Amavis
------

:doc:`index` runs on the following port: :ref:`glossary-TCP`
``10024``.

Clamav
------

:doc:`/clamav/doc/index` integration run on the following port:
:ref:`glossary-TCP` ``3310``.
