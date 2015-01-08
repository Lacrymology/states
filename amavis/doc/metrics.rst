Metrics
=======

:doc:`/diamond/doc/process`:

* ``amavis`` (:doc:`/amavis/doc/index` daemon and all its subprocesses).

Amavis
------

:doc:`/amavis/doc/index` receives emails from MTA
(e.g :doc:`/postfix/doc/index`)
and perform spam filtering and/or virus scanning on those emails.
These metrics are statistics of :doc:`/amavis/doc/index` daemon about its
email processing.

Unit:

- size: MB.
- count: number of messages / log entries / connections ...
- frequency: unit/hour.
- percentage: %.
- time: seconds.

amavis.CacheAttempts.count
~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of cache attempts.

amavis.CacheAttempts.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of cache attempts.

amavis.CacheAttempts.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of cache attempts.

amavis.CacheMisses.count
~~~~~~~~~~~~~~~~~~~~~~~~

Times of cache misses.

amavis.CacheMisses.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of cache misses.

amavis.CacheMisses.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of cache misses.

amavis.ContentCleanMsgs.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of content clean messages.

amavis.ContentCleanMsgs.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of content clean messages.

amavis.ContentCleanMsgs.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of content clean messages.

amavis.ContentCleanMsgsInternal.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of content clean messages internal.

amavis.ContentCleanMsgsInternal.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of content clean messages internal.

amavis.ContentCleanMsgsInternal.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of content clean messages internal.

amavis.ContentCleanMsgsOriginating.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of content clean messages originating.

amavis.ContentCleanMsgsOriginating.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of content clean messages originating.

amavis.ContentCleanMsgsOriginating.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of content clean messages originating.

amavis.ContentSpamMsgs.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of content spam messages.

amavis.ContentSpamMsgs.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of content spam messages.

amavis.ContentSpamMsgs.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of content spam messages.

amavis.ContentSpamMsgsInternal.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of content spam messages internal.

amavis.ContentSpamMsgsInternal.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of content spam messages internal.

amavis.ContentSpamMsgsInternal.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of content spam messages internal.

amavis.ContentSpamMsgsOriginating.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of content spam messages originating.

amavis.ContentSpamMsgsOriginating.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of content spam messages originating.

amavis.ContentSpamMsgsOriginating.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of content spam messages originating.

amavis.InMsgs.count
~~~~~~~~~~~~~~~~~~~

Times of inbound messages.

amavis.InMsgs.percentage
~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of inbound messages.

amavis.InMsgs.frequency
~~~~~~~~~~~~~~~~~~~~~~~

Frequency of inbound messages.

amavis.InMsgsInternal.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of inbound messages internal.

amavis.InMsgsInternal.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of inbound messages internal.

amavis.InMsgsInternal.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of inbound messages internal.

amavis.InMsgsOriginating.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of inbound messages originating.

amavis.InMsgsOriginating.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of inbound messages originating.

amavis.InMsgsOriginating.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of inbound messages originating.

amavis.InMsgsRecips.count
~~~~~~~~~~~~~~~~~~~~~~~~~

Times of inbound messages recipients.

amavis.InMsgsRecips.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of inbound messages recipients.

amavis.InMsgsRecips.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of inbound messages recipients.

amavis.InMsgsRecipsInternal.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of inbound messages recipients internal.

amavis.InMsgsRecipsInternal.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of inbound messages recipients internal.

amavis.InMsgsRecipsInternal.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of inbound messages recipients internal.

amavis.InMsgsRecipsLocal.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of inbound messages recipients local.

amavis.InMsgsRecipsLocal.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of inbound messages recipients local.

amavis.InMsgsRecipsLocal.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of inbound messages recipients local.

amavis.InMsgsRecipsOriginating.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of inbound messages recipients originating.

amavis.InMsgsRecipsOriginating.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of inbound messages recipients originating.

amavis.InMsgsRecipsOriginating.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of inbound messages recipients originating.

amavis.InMsgsSize.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of inbound messages size.

amavis.InMsgsSize.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of inbound messages size.

amavis.InMsgsSize.size
~~~~~~~~~~~~~~~~~~~~~~

Size of inbound messages size.

amavis.InMsgsSizeInternal.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of inbound messages size internal.

amavis.InMsgsSizeInternal.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of inbound messages size internal.

amavis.InMsgsSizeInternal.size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of inbound messages size internal.

amavis.InMsgsSizeOriginating.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of inbound messages size originating.

amavis.InMsgsSizeOriginating.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of inbound messages size originating.

amavis.InMsgsSizeOriginating.size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of inbound messages size originating.

amavis.InMsgsStatusRelayed.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of inbound messages status relayed.

amavis.InMsgsStatusRelayed.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of inbound messages status relayed.

amavis.InMsgsStatusRelayed.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of inbound messages status relayed.

amavis.LogEntries.count
~~~~~~~~~~~~~~~~~~~~~~~

Times of log entries.

amavis.LogEntries.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of log entries.

amavis.LogEntries.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of log entries.

amavis.LogEntriesDebug.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of log entries debug.

amavis.LogEntriesDebug.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of log entries debug.

amavis.LogEntriesDebug.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of log entries debug.

amavis.LogEntriesInfo.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of log entries info.

amavis.LogEntriesInfo.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of log entries info.

amavis.LogEntriesInfo.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of log entries info.

amavis.LogEntriesLevel0.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of log entries level0.

amavis.LogEntriesLevel0.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of log entries level0.

amavis.LogEntriesLevel0.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of log entries level0.

amavis.LogEntriesNotice.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of log entries notice.

amavis.LogEntriesNotice.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of log entries notice.

amavis.LogEntriesNotice.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of log entries notice.

amavis.LogLines.count
~~~~~~~~~~~~~~~~~~~~~

Times of log lines.

amavis.LogLines.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of log lines.

amavis.LogLines.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of log lines.

amavis.LogRetries.count
~~~~~~~~~~~~~~~~~~~~~~~

Times of log retries.

amavis.LogRetries.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of log retries.

amavis.LogRetries.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of log retries.

amavis.OpsDec.count
~~~~~~~~~~~~~~~~~~~

Times of operations decode.

amavis.OpsDec.percentage
~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of operations decode.

amavis.OpsDec.frequency
~~~~~~~~~~~~~~~~~~~~~~~

Frequency of operations decode.

amavis.OpsDecByMimeParser.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of operations decode by mime parser.

amavis.OpsDecByMimeParser.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of operations decode by mime parser.

amavis.OpsDecByMimeParser.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of operations decode by mime parser.

amavis.OpsSpamCheck.count
~~~~~~~~~~~~~~~~~~~~~~~~~

Times of operations spam check.

amavis.OpsSpamCheck.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of operations spam check.

amavis.OpsSpamCheck.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of operations spam check.

amavis.OutConnNew.count
~~~~~~~~~~~~~~~~~~~~~~~

Times of outbound connection new.

amavis.OutConnNew.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound connection new.

amavis.OutConnNew.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound connection new.

amavis.OutConnTransact.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of outbound connection transact.

amavis.OutConnTransact.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound connection transact.

amavis.OutConnTransact.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound connection transact.

amavis.OutMsgs.count
~~~~~~~~~~~~~~~~~~~~

Times of outbound messages.

amavis.OutMsgs.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages.

amavis.OutMsgs.frequency
~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages.

amavis.OutMsgsDelivers.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of outbound messages delivers.

amavis.OutMsgsDelivers.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages delivers.

amavis.OutMsgsDelivers.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages delivers.

amavis.OutMsgsProtoLocal.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of outbound messages protocol local.

amavis.OutMsgsProtoLocal.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages protocol local.

amavis.OutMsgsProtoLocal.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages protocol local.

amavis.OutMsgsProtoLocalSubmit.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of outbound messages protocol local submit.

amavis.OutMsgsProtoLocalSubmit.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages protocol local submit.

amavis.OutMsgsProtoLocalSubmit.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages protocol local submit.

amavis.OutMsgsProtoSMTP.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of outbound messages protocol SMTP.

amavis.OutMsgsProtoSMTP.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages protocol SMTP.

amavis.OutMsgsProtoSMTP.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages protocol SMTP.

amavis.OutMsgsProtoSMTPRelay.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of outbound messages protocol SMTP relay.

amavis.OutMsgsProtoSMTPRelay.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages protocol SMTP relay.

amavis.OutMsgsProtoSMTPRelay.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages protocol SMTP relay.

amavis.OutMsgsRelay.count
~~~~~~~~~~~~~~~~~~~~~~~~~

Times of outbound messages relay.

amavis.OutMsgsRelay.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages relay.

amavis.OutMsgsRelay.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages relay.

amavis.OutMsgsSize.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages size.

amavis.OutMsgsSize.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages size.

amavis.OutMsgsSize.size
~~~~~~~~~~~~~~~~~~~~~~~

Size of outbound messages size.

amavis.OutMsgsSizeProtoLocal.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages size protocol local.

amavis.OutMsgsSizeProtoLocal.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages size protocol local.

amavis.OutMsgsSizeProtoLocal.size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of outbound messages size protocol local.

amavis.OutMsgsSizeProtoLocalSubmit.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages size protocol local submit.

amavis.OutMsgsSizeProtoLocalSubmit.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages size protocol local submit.

amavis.OutMsgsSizeProtoLocalSubmit.size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of outbound messages size protocol local submit.

amavis.OutMsgsSizeProtoSMTP.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages size protocol SMTP.

amavis.OutMsgsSizeProtoSMTP.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages size protocol SMTP.

amavis.OutMsgsSizeProtoSMTP.size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of outbound messages size protocol SMTP.

amavis.OutMsgsSizeProtoSMTPRelay.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages size protocol SMTP relay.

amavis.OutMsgsSizeProtoSMTPRelay.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages size protocol SMTP relay.

amavis.OutMsgsSizeProtoSMTPRelay.size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of outbound messages size protocol SMTP relay.

amavis.OutMsgsSizeRelay.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages size relay.

amavis.OutMsgsSizeRelay.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages size relay.

amavis.OutMsgsSizeRelay.size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of outbound messages size relay.

amavis.OutMsgsSizeSubmit.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages size submit.

amavis.OutMsgsSizeSubmit.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages size submit.

amavis.OutMsgsSizeSubmit.size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of outbound messages size submit.

amavis.OutMsgsSizeSubmitQuar.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages size submit quarantine.

amavis.OutMsgsSizeSubmitQuar.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages size submit quarantine.

amavis.OutMsgsSizeSubmitQuar.size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of outbound messages size submit quarantine.

amavis.OutMsgsSubmit.count
~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of outbound messages submit.

amavis.OutMsgsSubmit.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages submit.

amavis.OutMsgsSubmit.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages submit.

amavis.OutMsgsSubmitQuar.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of outbound messages submit quarantine.

amavis.OutMsgsSubmitQuar.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of outbound messages submit quarantine.

amavis.OutMsgsSubmitQuar.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of outbound messages submit quarantine.

amavis.QuarMsgs.count
~~~~~~~~~~~~~~~~~~~~~

Times of quarantine messages.

amavis.QuarMsgs.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of quarantine messages.

amavis.QuarMsgs.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of quarantine messages.

amavis.QuarMsgsSize.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of quarantine messages size.

amavis.QuarMsgsSize.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of quarantine messages size.

amavis.QuarMsgsSize.size
~~~~~~~~~~~~~~~~~~~~~~~~

Size of quarantine messages size.

amavis.QuarMsgsSizeSpam.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of quarantine messages size spam.

amavis.QuarMsgsSizeSpam.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of quarantine messages size spam.

amavis.QuarMsgsSizeSpam.size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Size of quarantine messages size spam.

amavis.QuarMsgsSpam.count
~~~~~~~~~~~~~~~~~~~~~~~~~

Times of quarantine messages spam.

amavis.QuarMsgsSpam.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of quarantine messages spam.

amavis.QuarMsgsSpam.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of quarantine messages spam.

amavis.TimeElapsedDecoding.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of time elapsed decoding.

amavis.TimeElapsedDecoding.time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Seconds of time elapsed decoding.

amavis.TimeElapsedReceiving.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of time elapsed receiving.

amavis.TimeElapsedReceiving.time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Seconds of time elapsed receiving.

amavis.TimeElapsedSending.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of time elapsed sending.

amavis.TimeElapsedSending.time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Seconds of time elapsed sending.

amavis.TimeElapsedSpamCheck.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of time elapsed spam check.

amavis.TimeElapsedSpamCheck.time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Seconds of time elapsed spam check.

amavis.TimeElapsedTotal.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of time elapsed total.

amavis.TimeElapsedTotal.time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Seconds of time elapsed total.

amavis.OpsDecType-asc.count
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Times of operations decode type-asc.

amavis.OpsDecType-asc.percentage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Percentage of operations decode type-asc.

amavis.OpsDecType-asc.frequency
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Frequency of operations decode type-asc.
