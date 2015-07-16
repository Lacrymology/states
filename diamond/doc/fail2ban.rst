..
   Author: Quan Tong Anh <quanta@robotinfra.com>
   Maintainer: Quan Tong Anh <quanta@robotinfra.com>

Fail2ban
========

If a service is integrated with :doc:`/fail2ban/doc/index`, then the number of
banned IPs will be monitored and send to :doc:`/graphite/doc/index` to plot a
graph.

By default, the banning action is ``hostsdeny`` which means that using
:ref:`glossary-TCP-Wrapper` to add a host into ``/etc/hosts.deny``. There are
some pre-defined other actions like: ``iptables``, ``shorewall``, ``sendmail``,
... If it is ``iptables``, then this package must be installed first in order
to count the number of blocked hosts based on a specific rule.
