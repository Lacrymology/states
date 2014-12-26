Monitor
=======

Mandatory
---------

.. |deployment| replace:: postfix

.. _monitor-postfix_qmgr:

postfix_qmgr
~~~~~~~~~~~~

`Postfix Queue manager <http://www.postfix.org/qmgr.8.html>`__ daemon awaits
the arrival of incoming mail and arranges for its delivery via
:doc:`/postfix/doc/index` delivery processes.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-postfix_pickup:

postfix_pickup
~~~~~~~~~~~~~~

`Postfix Local mail pickup <http://www.postfix.org/pickup.8.html>`__
daemon waits for hints that new mail has been dropped
into the ``maildrop`` directory, and feeds it into the
`cleanup <http://www.postfix.org/cleanup.8.html>`__ daemon.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-postfix_master:

postfix_master
~~~~~~~~~~~~~~

`Postfix Master <www.postfix.org/master.8.html>`__ daemon is the resident
process that runs :doc:`/postfix/doc/index` daemons on demand:
daemons to send or receive messages via the network,
daemons to deliver mail locally, etc.
These daemons are created on demand up to a configurable maximum number per
service.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-postfix_port_smtp:

postfix_port_smtp
~~~~~~~~~~~~~~~~~

:doc:`/postfix/doc/index` `SMTP <http://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol>`__
Port is listening locally.

.. _monitor-postfix_port_smtps:

postfix_port_smtps
~~~~~~~~~~~~~~~~~~

:doc:`/postfix/doc/index` SMTP Port over :doc:`/ssl/doc/index` is listening
locally.

.. include:: /backup/doc/monitor.inc

.. include:: /backup/doc/monitor_procs.inc

Optional
--------

.. _monitor-postfix_port_spam_handler:

postfix_port_spam_handler
~~~~~~~~~~~~~~~~~~~~~~~~~

`Postfix SPAM handler port <http://www.ijs.si/software/amavisd/README.postfix.txt>`__
is listening locally.
Only check if :ref:`pillar-postfix-spam_filter` enabled.
