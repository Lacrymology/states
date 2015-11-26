Monitor
=======

Mandatory
---------

.. _monitor-dovecot_master_procs:

dovecot_master_procs
~~~~~~~~~~~~~~~~~~~~

``dovecot`` process is the :doc:`index` master process which keeps everything
running.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-dovecot_config_procs:

dovecot_config_procs
~~~~~~~~~~~~~~~~~~~~

``dovecot/config`` :ref:`glossary-daemon` parses the configuration file and
sends the configuration to other processes.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-dovecot_log_procs:

dovecot_log_procs
~~~~~~~~~~~~~~~~~

``dovecot/log`` writes to log files. All logging, except from master process,
goes through it.

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-dovecot_anvil_procs:

dovecot_anvil_procs
~~~~~~~~~~~~~~~~~~~

``anvil`` keeps track of user connections

.. include:: /nrpe/doc/check_procs.inc

.. _monitor-dovecot_imap:

dovecot_imap
~~~~~~~~~~~~

:doc:`index` :ref:`glossary-imap` protocol is functional.

.. _monitor-dovecot_pop:

dovecot_pop
~~~~~~~~~~~

:doc:`index` :ref:`glossary-pop3` protocol is functional.

.. _monitor-dovecot_managesieve_port:

dovecot_managesieve_port
~~~~~~~~~~~~~~~~~~~~~~~~

`Dovecot Managesieve <http://wiki2.dovecot.org/Pigeonhole/ManageSieve>`_
port is listening and can be accessed locally.

.. _monitor-dovecot_managesieve_port_ipv6:

dovecot_managesieve_port_ipv6
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-dovecot_managesieve_port` but using :ref:`glossary-IPv6`.

.. _monitor-dovecot_port_imap:

dovecot_port_imap
~~~~~~~~~~~~~~~~~

Dovecot :ref:`glossary-imap` Port port is listening and can be accessed
locally.

.. _monitor-dovecot_port_imap_ipv6:

dovecot_port_imap_ipv6
~~~~~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-dovecot_port_imap` but using :ref:`glossary-IPv6`.

.. _monitor-dovecot_port_pop3:

dovecot_port_pop3
~~~~~~~~~~~~~~~~~

Dovecot :ref:`glossary-pop3` Port port is listening and can be accessed locally.

.. _monitor-dovecot_port_pop3_ipv6:

dovecot_port_pop3_ipv6
~~~~~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-dovecot_port_pop3` but using :ref:`glossary-IPv6`.

Optional
--------

.. _monitor-dovecot_spop:

dovecot_spop
~~~~~~~~~~~~

:doc:`index` :ref:`glossary-pop3` protocol over :doc:`/ssl/doc/index` is
functional.

.. _monitor-dovecot_simap:

dovecot_simap
~~~~~~~~~~~~~

:doc:`index` :ref:`glossary-imap` protocol over :doc:`/ssl/doc/index` is
functional.

.. _monitor-dovecot_port_pop3s:

dovecot_port_pop3s
~~~~~~~~~~~~~~~~~~

Dovecot POP3S Port port is listening and can be accessed locally.

.. _monitor-dovecot_port_pop3s_ipv6:

dovecot_port_pop3s_ipv6
~~~~~~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-dovecot_port_pop3s` but using :ref:`glossary-IPv6`.

.. _monitor-dovecot_port_imaps:

dovecot_port_imaps
~~~~~~~~~~~~~~~~~~

Dovecot IMAPS port is listening and can be accessed locally.

.. _monitor-dovecot_port_imaps_ipv6:

dovecot_port_imaps_ipv6
~~~~~~~~~~~~~~~~~~~~~~~

Same as :ref:`monitor-dovecot_port_imaps` but using :ref:`glossary-IPv6`.
