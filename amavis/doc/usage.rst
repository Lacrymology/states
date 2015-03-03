Usage
=====

More can be find at official
`Amavisd documentation <http://www.ijs.si/software/amavisd/amavisd-new-docs.html>`_.

Scan email content
------------------

:doc:`/amavis/doc/index` is a high-performance interface between mailer
(:ref:`glossary-MTA`) and content checkers:

- virus scanners (:doc:`/clamav/doc/index`)
- spam scanners (:doc:`/spamassassin/doc/index`)

:ref:`glossary-MTA` (:doc:`/postfix/doc/index`) will transport email message to
:doc:`/amavis/doc/index` daemon, this will do all configured checks then
action depends on the check results.

For spam scanning with :doc:`/spamassassin/doc/index`, after received an email
from :ref:`glossary-MTA`, :doc:`/amavis/doc/index` passes it to
:doc:`/spamassassin/doc/index`. :doc:`/spamassassin/doc/index` then scans it,
returns a spam score (spam level, hits) which is an floating number represents
for spaminess. The higher the number, the more spamy the message is considered.
:doc:`/amavis/doc/index` compares that score with three configured values then
decide what to do base on the comparation results.

- tag level::

    If spam score is at or above tag level, spam-related header fields
    (``X-Spam-Status`` and ``X-Spam-Level``) are inserted for local recipients;
    ``undefined`` (unknown) spam score is interpreted as lower than any spam
    score.

- tag2 level::

    If spam score is at or above tag2 level, spam-related header fields
    (``X-Spam-Status``, ``X-Spam-Level``, ``X-Spam-Flag`` and ``X-Spam-Report``)
    are inserted for local recipients, and ``X-Spam-Flag`` and ``X-Spam-Status``
    bear a ``YES``; also recipient address extension (if enabled) is tacked onto
    recipient address for local recipients; for these actions to have any
    effect, mail must be allowed to be delivered to a recipient.

- kill level::

    If spam score is at or above kill level, mail is blocked; and sender
    receives a nondelivery notification unless spam score exceeds dsn cutoff
    level.

Consult
`Tagkill doc <http://www.ijs.si/software/amavisd/amavisd-new-docs.html#tagkill>`_
for more infomation.
