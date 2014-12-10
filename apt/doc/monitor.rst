Monitor
=======

Mandatory
---------

.. _monitor-apt:

apt
~~~

There is no package available for upgrade.

If the check is WARNING, it will report number of packages need to be upgraded
on its output (can be see on :doc:`/shinken/doc/index` web UI). It returns
CRITICAL when there is any security upgrade need to be performed.
Running ``sudo apt-get upgrade`` suffices to fix this problem.

.. _monitor-apt_rc:

apt_rc
~~~~~~

There is no package which is removed but its configuration files still exist
on system.

If the check is not OK, an manually intervention may need to be performed:
- Get list of package in ``rc`` state::

      dpkg --list |grep "^rc"

- Purge package::

      sudo dpkg --purge package-name

Consult ``man 1 dpkg`` or
http://manpages.ubuntu.com/manpages/precise/man1/dpkg.1.html for more detail.
