..
   Author: Quan Tong Anh <quanta@robotinfra.com>
   Maintainer: Quan Tong Anh <quanta@robotinfra.com>

Fail2ban
========

Introduction
------------

.. Copied from http://www.fail2ban.org/wiki/index.php/Main_Page on 2015-01-13

:doc:`index` scans log files (e.g. /var/log/apache/error_log) and bans IPs that
show the malicious signs -- too many password failures, seeking for exploits,
etc. Generally :doc:`index` is then used to update firewall rules to reject the
IP addresses for a specified amount of time, although any arbitrary other action
(e.g. sending an email) could also be configured. Out of the box :doc:`index`
comes with filters for various services (apache, courier, ssh, etc).

.. toctree::
    :glob:

    *
