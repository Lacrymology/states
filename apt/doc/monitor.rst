Monitor
=======

Mandatory
---------

.. _monitor-apt:

apt
~~~

If there is any package available for upgrade.

If the check status is ``WARNING``, it will report number of packages need to
be upgraded. Status is ``CRITICAL`` if there is any security upgrade need to
be performed.

Running ``sudo apt-get upgrade`` will fix this problem. If
:ref:`pillar-salt-highstate` and :ref:`pillar-apt-upgrade` are ``True``
packages will be upgraded in the next day.

.. _monitor-apt_rc:

apt_rc
~~~~~~

There is no package which is removed but its configuration files still exists
on system.

If the check is not ``OK``, maybe a manual intervention is needed, such as:

- Get list of package in ``rc`` state::

      dpkg --list |grep "^rc"

- Purge package::

      sudo dpkg --purge package-name

Consult `dpkg man page <http://manpages.ubuntu.com/manpages/precise/man1/dpkg.1.html>`_
for more detail.
