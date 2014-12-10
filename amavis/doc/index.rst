Amavis
======

Homepage: http://www.ijs.si/software/amavisd/

.. note::

    Consult :doc:`/mail/doc/index` for setting up a full-stack mail system.

Contents:

.. toctree::
    :glob:

    *

Amavisd-new
-----------

This is the real name of software provided by this formula.
``amavisd-new`` grew out of ``amavisd`` (which in turn is a daemonized version
of amavis-perl), but through five years of development turned into a
separate product, hardly resembling its origin.
The code is several times the size of its predecessor. See
http://www.ijs.si/software/amavisd/ for more information. Every use of
``amavisd`` or ``amavis`` is this documentation implies ``amavisd-new``.


Using Amavis for checking email content
---------------------------------------

:doc:`/amavis/doc/index/` is a high-performance interface between mailer (MTA)
and content checkers: virus scanners (e.g. clamav, ...), and/or spam scanners
(e.g. :doc:`/spamassassin/doc/index`, ...).

MTA (e.g. :doc:`/postfix/doc/index`) will transport email message to
:doc:`/amavis/doc/index/` daemon, this will do all configured checks then
action depends on the check results.

For spam scanning with :doc:`/spamassassin/doc/index`, after received an email
from MTA, :doc:`/amavis/doc/index/` passes it to
:doc:`/spamassassin/doc/index`. :doc:`/spamassassin/doc/index` then scans it,
returns a spam score (spam level, hits) which is an floating number represents
for spaminess. The higher the number, the more spamy the message is considered.
:doc:`/amavis/doc/index/` compares that score with three configured values then
decide what to do base on the comparation results.

- tag level::

    if spam score is at or above tag level, spam-related header fields
    (X-Spam-Status, X-Spam-Level) are inserted for local recipients; undefined
    (unknown) spam score is interpreted as lower than any spam score.

- tag2 level::

    if spam score is at or above tag2 level, spam-related header fields
    (X-Spam-Status, X-Spam-Level, X-Spam-Flag and X-Spam-Report)
    are inserted for local recipients, and X-Spam-Flag and X-Spam-Status bear
    a YES; also recipient address extension (if enabled) is tacked onto
    recipient address for local recipients; for these actions to have any
    effect, mail must be allowed to be delivered to a recipient.

- kill level::

    if spam score is at or above kill level, mail is blocked; and sender
    receives a nondelivery notification unless spam score exceeds dsn cutoff
    level.


Consult http://www.ijs.si/software/amavisd/amavisd-new-docs.html#tagkill for
more infomation.
