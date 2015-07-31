Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Optional
--------

Example::

  fail2ban:
    whitelist:
      - 127.0.0.1/8
      - 192.168.1.1
    debug: 3
    bantime: 600
    findtime: 600
    maxretry: 3
    usedns: warn
    action: action_mw
    banaction: iptables-multiport

.. _pillar-fail2ban-whitelist:

fail2ban:whitelist
~~~~~~~~~~~~~~~~~~

An IP address, a CIDR mask or a hostname. Fail2ban will not ban a host which
matches an address in this list.

Default: Loopback addresses (``['127.0.0.1/8']``).

.. _pillar-fail2ban-debug:

fail2ban:debug
~~~~~~~~~~~~~~

If ``True``, log at level ``4``. If not, log at level ``3``.

Default: Log at INFO level (``3``).

.. _pillar-fail2ban-bantime:

fail2ban:bantime
~~~~~~~~~~~~~~~~

The number of seconds that a host is banned (after that, it will be un-banned).

Default: ``600`` seconds.

.. _pillar-fail2ban-maxretry:

fail2ban:maxretry
~~~~~~~~~~~~~~~~~

The number of times that a host can try during the last
:ref:`pillar-fail2ban-findtime` before it is banned.

Default: ``3`` times.

.. _pillar-fail2ban-findtime:

fail2ban:findtime
~~~~~~~~~~~~~~~~~

A host is banned if it has generated :ref:`pillar-fail2ban-maxretry` attempts
during the given time.

Default: ``600`` seconds.

.. _pillar-fail2ban-usedns:

fail2ban:usedns
~~~~~~~~~~~~~~~

Whether if jails should trust hostnames in logs.

* yes: if a hostname is encountered, a reverse DNS lookup will be performed.

* warn: if a hostname is encountered, a reverse DNS lookup will be performed,
  but it will be logged as a warning.

* no: if a hostname is encountered, will not be used for banning, but it will
  be logged as info.

Default: ``warn``.

.. _pillar-fail2ban-action:

fail2ban:action
~~~~~~~~~~~~~~~

The action that :doc:`index` takes when it wants to institute a ban.

Available values:

* ``action_``: ban only
* ``action_mw``: ban and send an e-mail with whois report to the
  :ref:`pillar-fail2ban-destemail`
* ``action_mwl``: ban and send an e-mail with whois report and relevant log
  lines to the :ref:`pillar-fail2ban-destemail`

Default: ``action_`` (configure the firewall to reject traffic from the
offending host until the ban time elapses).

.. _pillar-fail2ban-banaction:

fail2ban:banaction
~~~~~~~~~~~~~~~~~~

Default banning action (e.g. iptables, iptables-new, iptables-multiport,
shorewall, etc)

It is used to define ``action_*`` variables.

Default: ``hostsdeny``.

Conditional
-----------

Example::

  fail2ban:
    destemail: team@example.com
    sendername: Fail2Ban
    mta: sendmail

Only defined if the value of :ref:`pillar-fail2ban-action` is different than
`action_`.

.. _pillar-fail2ban-destemail:

fail2ban:destemail
~~~~~~~~~~~~~~~~~~

Destination email address used solely for the interpolations in
jail.{conf,local} configuration files.

.. _pillar-fail2ban-sendername:

fail2ban:sendername
~~~~~~~~~~~~~~~~~~~

Name of the sender for `mta
<http://en.wikipedia.org/wiki/Message_transfer_agent>`_ actions.

Default: ``Fail2Ban``.

.. _pillar-fail2ban-mta:

fail2ban:mta
~~~~~~~~~~~~

Which MTA will be used for the mailling.

Default: ``sendmail``.
