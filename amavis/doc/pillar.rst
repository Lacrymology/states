Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/mail/doc/index` :doc:`/mail/doc/pillar`

Optional
--------

Example::

  mail:
    maxproc: 2
  amavis:
    check_virus: False
    warn_spam_sender: True
    notify_admin_for_spam: True

.. _pillar-amavis-check_virus:

amavis:check_virus
~~~~~~~~~~~~~~~~~~

Enable or disable virus checking for mail content.

Default: enable virus checking (``True``).

.. _pillar-amavis-warn_spam_sender:

amavis:warn_spam_sender
~~~~~~~~~~~~~~~~~~~~~~~

Notify spam sender or not.

Default: do not notify (``False``).

.. warning::

  It's not recommended to set this to ``True`` as it might generate a
  lot of new email to probably non-existing email account.

.. _pillar-amavis-notify_admin_for_spam:

amavis:notify_admin_for_spam
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Whether to send notifications to admin about spam emails.

Default: do not send (``False``).

If set to ``True``, notifications email will be sent
to user defined in :ref:`pillar-mail-postmaster`.

.. _pillar-amavis-sa_tag_level:

amavis:sa_tag_level
~~~~~~~~~~~~~~~~~~~

Add :doc:`/spamassassin/doc/index` tag to all emails have score greater than set value.

Default: a very low value to set spam info headers for all emails (``-999``).
This help user ensuring that email is processed by :doc:`/amavis/doc/index` by
just looking into email header.

.. _pillar-amavis-sa_tag2_level:

amavis:sa_tag2_level
~~~~~~~~~~~~~~~~~~~~

Emails which have score greater than this value considered "spammy"
(looks like spam), add spammy tag for it.

Default: value from example configuration file comes with amavasd-new package
on Ubuntu 12.04 which locates at
`/usr/share/doc/amavisd-new/examples/amavisd.conf-sample.gz` (``2``).
According to this example file,
this value should set to :ref:`pillar-amavis-sa_tag_level` but because that
pillar key is used in special purpose explained in
:ref:`pillar-amavis-sa_tag_level` , then this pillar value will act
as spammy threshold.

.. _pillar-amavis-sa_kill_level:

amavis:sa_kill_level
~~~~~~~~~~~~~~~~~~~~

Email spam score exceeds this value is considered spam.

Default: Using same value in example file mentioned in
:ref:`pillar-amavis-sa_tag_level` (``6.31``) .

.. _pillar-amavis-dsn_cutoff_level:

amavis:dsn_cutoff_level
~~~~~~~~~~~~~~~~~~~~~~~

When spam score exceeds this pillar value, do not send delivery status
notification message.

Default: Using same value in example file mentioned in
:ref:`pillar-amavis-sa_tag_level` (``9``).
