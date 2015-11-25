Monitor
=======

Mandatory
---------

.. |deployment| replace:: postfix

.. _monitor-postfix_qmgr:

postfix_qmgr
~~~~~~~~~~~~

`Postfix Queue manager <http://www.postfix.org/qmgr.8.html>`_ daemon awaits
the arrival of incoming mail and arranges for its delivery via
:doc:`index` delivery processes.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-postfix_pickup:

postfix_pickup
~~~~~~~~~~~~~~

`Postfix Local mail pickup <http://www.postfix.org/pickup.8.html>`_
daemon waits for hints that new mail has been dropped
into the ``maildrop`` directory, and feeds it into the
`cleanup <http://www.postfix.org/cleanup.8.html>`_ daemon.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-postfix_master:

postfix_master
~~~~~~~~~~~~~~

`Postfix Master <www.postfix.org/master.8.html>`_ daemon is the resident
process that runs :doc:`index` daemons on demand:
daemons to send or receive messages via the network,
daemons to deliver mail locally, etc.
These daemons are created on demand up to a configurable maximum number per
service.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-postfix_port_smtp:

postfix_port_smtp
~~~~~~~~~~~~~~~~~

:doc:`index` :ref:`glossary-smtp` Port is listening locally.

.. _monitor-postfix_port_smtp_ipv6:

postfix_port_smtp_ipv6
~~~~~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-postfix_port_smtp` but for :ref:`glossary-IPv6`.

postfix_queue_length
~~~~~~~~~~~~~~~~~~~~

Check the number of messages in the :doc:`index` queue.

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc

Optional
--------

.. _monitor-postfix_port_spam_handler:

postfix_port_spam_handler
~~~~~~~~~~~~~~~~~~~~~~~~~

`Postfix SPAM handler port
<http://www.ijs.si/software/amavisd/README.postfix.txt>`_
is listening locally.
Only check if :ref:`pillar-postfix-spam_filter` enabled.

.. _monitor-postfix_port_smtps:

postfix_port_smtps
~~~~~~~~~~~~~~~~~~

:doc:`index` :ref:`glossary-smtp` port over :doc:`/ssl/doc/index` is listening
locally.

.. _monitor-postfix_port_smtps_ipv6:

postfix_port_smtps_ipv6
~~~~~~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-postfix_port_smtps` but for :ref:`glossary-IPv6`.

Only check if :ref:`pillar-postfix-ssl` is turned on.
