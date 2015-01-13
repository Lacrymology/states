Pillar
======

.. include:: /doc/include/add_pillar.inc

- :doc:`/apt/doc/index` :doc:`/apt/doc/pillar`
- :doc:`/rsyslog/doc/index` :doc:`/rsyslog/doc/pillar`

Optional
--------

Example::

  fail2ban:
    loglevel: 3
    bantime: 600
    findtime: 600
    maxretry: 3
    backend: auto
    usedns: warn
    destemail: root@localhost
    sendername: Fail2Ban
    banaction: iptables-multiport

.. _pillar-fail2ban-loglevel:

fail2ban:loglevel
~~~~~~~~~~~~~~~~~

Set the log level output.

* 1 = ERROR
* 2 = WARN
* 3 = INFO
* 4 = DEBUG

Default: Log at INFO level (``3``).

.. _pillar-fail2ban-bantime:

fail2ban:bantime
~~~~~~~~~~~~~~~~

The number of seconds that a host is banned.

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

A host is banned if it has generated :ref:`pillar-fail2ban-maxretry` during the
given time.

Default: ``600`` seconds.

.. _pillar-fail2ban-backend:

fail2ban:backend
~~~~~~~~~~~~~~~~

The backend used to get files modification.
Available options are "pyinotify", "gamin", "polling" and "auto".
This option can be overridden in each jail as well.

* pyinotify: requires pyinotify (a file alteration monitor) to be installed.
  If pyinotify is not installed, Fail2ban will use auto.

* gamin: requires Gamin (a file alteration monitor) to be installed.
  If Gamin is not installed, Fail2ban will use auto.

* polling: uses a polling algorithm which does not require external libraries.

* auto: will try to use the following backends, in order: pyinotify, gamin,
  polling.

Default: ``False`` - use auto backedn.

.. _pillar-fail2ban-usedns:

fail2ban:usedns
~~~~~~~~~~~~~~~

Whether if jails should trust hostnames in logs.

* yes: if a hostname is encountered, a reverse DNS lookup will be performed.

* warn: if a hostname is encountered, a reverse DNS lookup will be performed,
  but it will be logged as a warning.

* no: if a hostname is encountered, will not be used for banning, but it will
  be logged as info.

Default: ``False`` - use warn.

.. _pillar-fail2ban-destemail:

fail2ban:destemail
~~~~~~~~~~~~~~~~~~

Destination email address used solely for the interpolations in
jail.{conf,local} configuration files.

Default: ``False`` - use `root@localhost`.

.. _pillar-fail2ban-sendername:

fail2ban:sendername
~~~~~~~~~~~~~~~~~~~

Name of the sender for mta actions.

Default: ``False`` - use `Fail2Ban`.

.. _pillar-fail2ban-banaction:

fail2ban:banaction
~~~~~~~~~~~~~~~~~~

Default banning action (e.g. iptables, iptables-new, iptables-multiport,
shorewall, etc)

It is used to define ``action_*`` variables.

Default: ``False`` - use `iptables-multiport`.
