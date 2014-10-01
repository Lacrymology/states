Amavis
======

Consult :doc:`/mail/doc/index` for setting up a full-stack mail system.

Contents:

.. toctree::
    :glob:

    *

Using amavisd-new for checking email content
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

amavisd-new is a high-performance interface between mailer (MTA) and content
checkers: virus scanners (e.g. clamav, ...), and/or spam scanners
(e.g. SpamAssassin, ...).

MTA (e.g. Postfix) will transport email message to amavisd-new daemon,
this will do all configured checks then action depends on the check results.

For spam scanning with SpamAssassin, after received an email from MTA,
amavisd-new passes it to SpamAssassin. SpamAssassin then scans it,
returns a spam score (spam level, hits) which is an floating number represents
for spaminess. The higher the number, the more spamy the message is considered.
amavisd-new compares that score with three configured values then
decide what to do base on the comparation results.

- tag level::

    if spam score is at or above tag level, spam-related header fields
    (X-Spam-Status, X-Spam-Level) are inserted for local recipients; undefined
    (unknown) spam score is interpreted as lower than any spam score.

- tag2 level::

    if spam score is at or above tag2 level, spam-related header fields
    (X-Spam-Status, X-Spam-Level, X-Spam-Flag and X-Spam-Report) are inserted for
    local recipients, and X-Spam-Flag and X-Spam-Status bear a YES; also recipient
    address extension (if enabled) is tacked onto recipient address for local
    recipients; for these actions to have any effect, mail must be allowed to be
    delivered to a recipient.

- kill level::

    if spam score is at or above kill level, mail is blocked; and sender
    receives a nondelivery notification unless spam score exceeds dsn cutoff
    level.


Consult http://www.ijs.si/software/amavisd/amavisd-new-docs.html#tagkill for
more infomation.
