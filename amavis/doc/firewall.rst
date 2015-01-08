Firewall
========

.. include:: /doc/include/add_firewall.inc

- :doc:`/spamassassin/doc/index` :doc:`/spamassassin/doc/firewall`

.. warning::

  These 2 :ref:`glossary-daemon` don't need to be open unless it's plan to be
  run on a separated hosts as the :doc:`/mail/server/doc/index`. Which is not
  usually the case.

  In case of doubt, don't allow traffic in for these.

Amavis
------

:doc:`/amavis/doc/index` run on the following port: :ref:`glossary-TCP`
``10024``.

Clamav
------

:doc:`/clamav/doc/index` integration run on the following port:
:ref:`glossary-TCP` ``3310``.
